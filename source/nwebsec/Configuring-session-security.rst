# Configuring session security
This is the documentation for the NWebsec.SessionSecurity 1.1 configuration.

Basic configuration is added to web.config when installing the NWebsec.SessionSecurity NuGet package. Here's what you'll see added to web.config (assembly version numbers will vary with releases):

```xml
<configuration>
  <configSections>
    <sectionGroup name="nwebsec">
      <section name="sessionSecurity" type="NWebsec.SessionSecurity.Configuration.SessionSecurityConfigurationSection, NWebsec.SessionSecurity, Version=1.1.0.0, Culture=neutral, PublicKeyToken=3613da5f958908a1" requirePermission="false" allowDefinition="MachineToApplication" />
    </sectionGroup>
  </configSections>

<system.web>
    <sessionState sessionIDManagerType="NWebsec.SessionSecurity.SessionState.AuthenticatedSessionIDManager, NWebsec.SessionSecurity, Version=1.1.0.0, Culture=neutral, PublicKeyToken=3613da5f958908a1" />
</system.web>
  <system.webServer>
    <security>
      <requestFiltering>
        <hiddenSegments>
          <add segment="NWebsecConfig" />
        </hiddenSegments>
      </requestFiltering>
    </security>
  </system.webServer>
  <nwebsec>
<sessionSecurity xmlns="http://nwebsec.com/SessionSecurityConfig.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="NWebsecConfig/SessionSecurityConfig.xsd">
    </sessionSecurity>
  </nwebsec>
</configuration>
```

In short, The session security config section is declared, the sessionState element is configured with the AuthenticatedSessionIDManager, the NWebsec configuration directory is declared as a hidden segment, and an empty session security configuration section is added.

The configuration schema enables intellisense for the NWebsec.SessionSecurity configuration, so feel free to start of with the empty section and add the configuration you need.

Note that everything's disabled by default, so you need to enable the session fixation protection in config.

# Protecting session IDs under machineKey
If your application is set up with machineKeys, NWebsec.SessionSecurity can use the validation key to protect the session IDs. This makes for the simplest configuration:

```xml
<configuration>
...
  <nwebsec>
    <sessionSecurity ... >
      <sessionIDAuthentication enabled="true" />
    </sessionSecurity>
  </nwebsec>
...
</configuration>
```

Note that you'll get an exception if your application runs with medium trust, as the machineKey configuration is inaccessible under that trust level.

# Specifying a session authentication key
If your application runs with medium trust, you can specify a session authentication key in the sessionSecurity configuration. You should generate a proper key that's at least 256 bits, shorter keys will not be accepted. Here's the configuration section with the sessionAuthenticationKey specified:

```
<configuration>
...
  <nwebsec>
    <sessionSecurity ... >
      <sessionIDAuthentication enabled="true"
                               useMachineKey="false"
                               authenticationKey="0BFF..." />
    </sessionSecurity>
  </nwebsec>
...
</configuration>
```

# Specifying a session authentication key through AppSettings
You can also specify a key in an AppSetting, and refer to this in the session security configuration. This can be useful for Azure Websites. You should generate a proper key that's at least 256 bits, shorter keys will not be accepted. Here's an example:

```xml
<configuration>
<appSettings>
  <!--<add key="NWebsecSessionAuthenticationKey" value="0BFF..." />-->
</appSettings>
...
  <nwebsec>
    <sessionSecurity ... >
      <sessionIDAuthentication enabled="true"
                               useMachineKey="false"
                               authenticationKeyAppsetting="NWebsecSessionAuthenticationKey" />
    </sessionSecurity>
  </nwebsec>
...
</configuration>
```

For an Azure website you could set the key in an AppSetting through the portal to keep your secrets out of the web.config.