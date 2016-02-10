<?xml version="1.0" encoding="utf-8"?>
<serviceModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" name="NextGamesChatCloud" generation="1" functional="0" release="0" Id="3c462b4c-bb03-4cad-a114-8c70fde6ec43" dslVersion="1.2.0.0" xmlns="http://schemas.microsoft.com/dsltools/RDSM">
  <groups>
    <group name="NextGamesChatCloudGroup" generation="1" functional="0" release="0">
      <componentports>
        <inPort name="NextGamesChat:Endpoint1" protocol="http">
          <inToChannel>
            <lBChannelMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/LB:NextGamesChat:Endpoint1" />
          </inToChannel>
        </inPort>
      </componentports>
      <settings>
        <aCS name="NextGamesChat:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" defaultValue="">
          <maps>
            <mapMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/MapNextGamesChat:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" />
          </maps>
        </aCS>
        <aCS name="NextGamesChatInstances" defaultValue="[1,1,1]">
          <maps>
            <mapMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/MapNextGamesChatInstances" />
          </maps>
        </aCS>
      </settings>
      <channels>
        <lBChannel name="LB:NextGamesChat:Endpoint1">
          <toPorts>
            <inPortMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/NextGamesChat/Endpoint1" />
          </toPorts>
        </lBChannel>
      </channels>
      <maps>
        <map name="MapNextGamesChat:Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" kind="Identity">
          <setting>
            <aCSMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/NextGamesChat/Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" />
          </setting>
        </map>
        <map name="MapNextGamesChatInstances" kind="Identity">
          <setting>
            <sCSPolicyIDMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/NextGamesChatInstances" />
          </setting>
        </map>
      </maps>
      <components>
        <groupHascomponents>
          <role name="NextGamesChat" generation="1" functional="0" release="0" software="C:\Users\stanislav.stoyanov\Documents\visual studio 2015\Projects\NextGamesChat\NextGamesChatCloud\csx\Release\roles\NextGamesChat" entryPoint="base\x64\WaHostBootstrapper.exe" parameters="base\x64\WaIISHost.exe " memIndex="-1" hostingEnvironment="frontendadmin" hostingEnvironmentVersion="2">
            <componentports>
              <inPort name="Endpoint1" protocol="http" portRanges="80" />
            </componentports>
            <settings>
              <aCS name="Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" defaultValue="" />
              <aCS name="__ModelData" defaultValue="&lt;m role=&quot;NextGamesChat&quot; xmlns=&quot;urn:azure:m:v1&quot;&gt;&lt;r name=&quot;NextGamesChat&quot;&gt;&lt;e name=&quot;Endpoint1&quot; /&gt;&lt;/r&gt;&lt;/m&gt;" />
            </settings>
            <resourcereferences>
              <resourceReference name="DiagnosticStore" defaultAmount="[4096,4096,4096]" defaultSticky="true" kind="Directory" />
              <resourceReference name="EventStore" defaultAmount="[1000,1000,1000]" defaultSticky="false" kind="LogStore" />
            </resourcereferences>
          </role>
          <sCSPolicy>
            <sCSPolicyIDMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/NextGamesChatInstances" />
            <sCSPolicyUpdateDomainMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/NextGamesChatUpgradeDomains" />
            <sCSPolicyFaultDomainMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/NextGamesChatFaultDomains" />
          </sCSPolicy>
        </groupHascomponents>
      </components>
      <sCSPolicy>
        <sCSPolicyUpdateDomain name="NextGamesChatUpgradeDomains" defaultPolicy="[5,5,5]" />
        <sCSPolicyFaultDomain name="NextGamesChatFaultDomains" defaultPolicy="[2,2,2]" />
        <sCSPolicyID name="NextGamesChatInstances" defaultPolicy="[1,1,1]" />
      </sCSPolicy>
    </group>
  </groups>
  <implements>
    <implementation Id="2a2996d2-1d8a-4854-8e49-07fc6d15f6e7" ref="Microsoft.RedDog.Contract\ServiceContract\NextGamesChatCloudContract@ServiceDefinition">
      <interfacereferences>
        <interfaceReference Id="0fddd226-72f1-4825-b85f-e7eb03453a54" ref="Microsoft.RedDog.Contract\Interface\NextGamesChat:Endpoint1@ServiceDefinition">
          <inPort>
            <inPortMoniker name="/NextGamesChatCloud/NextGamesChatCloudGroup/NextGamesChat:Endpoint1" />
          </inPort>
        </interfaceReference>
      </interfacereferences>
    </implementation>
  </implements>
</serviceModel>