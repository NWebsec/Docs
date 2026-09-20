=================================
AuthenticatedSessionIDManager
=================================


The **NWebsec.SessionSecurity** library includes the **AuthenticatedSessionIDManager** which manages :doc:`Authenticated-session-identifiers`. Here are the nitty gritty details on how it works and an account of its security properties.

*************************
Authenticated session IDs
*************************

Authenticated session IDs are tied to the user through a Message Authentication Code (MAC). They're created in the following way:

"|| denotes concatenation."  
The key is 256 bits, derived from configured key (see `Key management <#key-management>`_).


#. 16 random bytes (128 bit) are generated with the RngCryptoServiceProvider, denoted randomID
#. The MAC is calculated over the username and randomID:
   mac = HMAC-Sha256(key, username || randomID)
#. The mac is appended to the randomID:
   binarySessionID = randomID || mac
#. The sessionID is the Base64 encoded binarySessionID:
   sessionID = Base64Encode(binarySessionID)

Validation of authenticated session IDs follows a similar pattern:

#. Check that the length of the received sessionID is correct (16+32 bytes)
#. Get the first 16 bytes of the received sessionID value, denoted receivedID.
#. Get the next 32 bytes of the received sessionID value, denoted receivedMac.
#. A MAC is calculated over the username and receivedID:
   mac = HMAC-Sha256(key, username || receivedID)
#. The mac is compared to the receivedMac:
   result = mac == receivedMac

   * Care has been taken to compare the mac in constant time to avoid timing attacks.

********
Security
********

By using a MAC (which relies on a secret key) calculated over a random ID and the username, it is unfeasible for an attacker to guess a valid session ID for another user. Also, an attacker cannot obtain session IDs from the application that would be valid for another user. They would only be valid for the attacker while she's logged on.

Unauthenticated users get the classic ASP.NET session behaviour as the AuthenticatedSessionIDManager falls back to the SessionIDManager behaviour. Hence, unauthenticated users could still be subject to session fixation attacks.

Key management
==============
Using a MAC requires a secret key. The session fixation protection permits the use of the validation key from the machineKey settings or the use of a configured sessionAuthentication key. However, neither of these keys would be used directly. There's an important security principle: Never reuse keys for different purposes. You should live, and die, by this principle.

In fact, they did a massive overhaul on how cryptographic keys were handled in ASP.NET 4.5: `Cryptographic Improvements in ASP.NET 4.5, pt. 2 <http://blogs.msdn.com/b/webdev/archive/2012/10/23/cryptographic-improvements-in-asp-net-4-5-pt-2.aspx>`_. This has inspired how keys are handled in NWebsec.SessionSecurity.

NWebsec.SessionSecurity contains an implementation of the NIST SP800-108 counter-mode KDF with HMACSHA256 (similar to what they use in ASP.NET 4.5), and uses this to derive the key used for session authentication. This is important, as the KDF is designed to ensure that derived keys are independent of each other security wise. If one key gets compromised that should not aid an attacker in compromising the master key or any other derived keys.

*************************************
Authenticated IDs vs. traditional IDs
*************************************

A design criteria for the AuthenticatedSessionIDManager is that it under no circumstance should offer less security than the traditional ASP.NET SessionIDManager. Considering the Authenticated Session IDs are generated as such:

>
key = 256 random bits from a cryptographically strong RNG  
randomID = 128 random bits from a cryptographically strong RNG  
username = some string  
sessionID = Base64Encode(randomID || HMACSHA256(key, username || randomID))

We'll have a look at how these session IDs compare to the traditional ASP.NET session IDs.

Keyspace and randomness
=======================

Traditional ASP.NET `session IDs <http://msdn.microsoft.com/en-us/library/system.web.sessionstate.sessionidmanager.createsessionid.aspx>`_ are 24 characters long, encoded with a character set that includes a-z and 0-5. Since the character set contains 32 characters, each character in the session ID represents a five bit value. 24 characters representing five bits each yields a 120-bit session ID. Consequently, the session ID key space (number of possible session IDs) is 2\ :sup:`120` for ASP.NET session IDs.

If we look at the edge case with a constant username we can determine the minimum key space for authenticated session IDs. The MAC is deterministic and does not add randomness, which means that the key space is determined by the randomID. Consequently, the key space in the edge case is 2\ :sup:`128` for authenticated session IDs.  A keyspace of 2\ :sup:`128` is much larger than one of 2\ :sup:`120` so the AuthenticatedSessionIDManager holds up to the ASP.NET Session SessionIDManager in terms of the number of possible session IDs.

You might consider the static username an odd case, but it's really not. If there's only one user in the system, this applies. Also, people (mis)use the framework in every (un)thinkable way, so it's a fair bet that someone out there decided it would be a good idea to shared the username between users, and differentiate them by other means. An example would be setting the username to "customer" and misuse that as a role, and keep the "logical" username in session.

If the username is constant, the session fixation protection will not be effective. You'll be back to the current model in ASP.NET session management, but most importantly you won't be worse off than you are today.

In terms of randomness, both the ASP.NET SessionIDManager and the NWebsec AuthenticatedSessionIDManager use the `RNGCryptoServiceProvider <http://msdn.microsoft.com/en-us/library/system.security.cryptography.rngcryptoserviceprovider.aspx>`_ as their source for random bits. There's not much more to say about that! You can expect the IDs to be random in either case. 

Cryptographic security
======================

HMACSHA256 still holds up security wise, which means that you'll get a 256-bit security level as long as you provide a properly generated 256-bit key. The security level refers to how much work an attacker would have to put in to be guaranteed success in a key recovery attack, i.e. the attacker would have to run through all 2\ :sup:`256` possible keys. On average, an attacker would have to try half the number of keys, which would be 2\ :sup:`255`. But don't worry, that's still a large number of keys (~5,79 * 10\ :sup:`76`).

Note that the security level is bound by the key you supply, so if you're using a 128-bit key, you'll get a 128-bit security level. Note that HMACSHA256 will hash keys longer than 256 bit, reducing them to a 256-bit key. So keys that are longer than 256 bit will not add to security (but they won't hurt security).

However, the major concern is not whether the attacker can calculate a valid session ID for another user. The session ID must be a collision, i.e. it would be valid for both the attacker and another user. There are no known attacks to date that would let an attacker generate collisions as long as the secret key remains secret.

You might wonder why HMACSHA256 was chosen for the MAC. Well, it provides good security and it's the default validation algorithm in machine key settings. It's also the required minimum in the `Microsoft SDL <http://www.microsoft.com/sdl>`_, version 5.2.

Acknowledgements
================

We thank crypto wiz `@tbj <https://twitter.com/tbj>`_ for his invaluable input on how to generate the authenticated session identifiers!  
