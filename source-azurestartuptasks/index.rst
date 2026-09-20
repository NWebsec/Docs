.. NWebsec documentation master file, created by
   sphinx-quickstart on Sun Oct 04 00:43:10 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

###########################################
NWebsec - TLS hardening for Azure web roles
###########################################

.. toctree::
   :maxdepth: 2
   :titlesonly:
   :hidden:

   TLS-hardening

NWebsec.AzureStartupTasks provides an Azure startup task to harden the TLS configuration of Azure instances. Note that the startup tasks are built for `Azure cloud services <http://www.windowsazure.com/en-us/services/cloud-services/>`_, they are not suitable for `Azure websites <http://www.windowsazure.com/en-us/services/web-sites/>`_.

You'll find the library on NuGet: `NWebsec.AzureStartupTasks <http://nuget.org/packages/NWebsec.AzureStartupTasks/>`_. You can also get it under `Releases <https://github.com/NWebsec/NWebsec.AzureStartupTasks/releases>`_ over at GitHub.

You can take advantage of the scripts in several ways:

* Cloud service project

  * Install the NuGet package in the web application project and add a few lines of config to the ServiceDefinition.csdef file in your cloud service project.
  * Download the scripts and add them with relevant configuration to your projects.

* Stand-alone servers

  * Download the package and user the PowerShell scripts directly.

To see how the configuration is hardened, refer to :doc:`TLS-hardening`. 

To learn why you should harden the default TLS configuration, see the blog post: `Hardening Windows Server 2008/2012 and Azure SSL/TLS configuration <http://www.dotnetnoob.com/2013/10/hardening-windows-server-20082012-and.html>`_.

