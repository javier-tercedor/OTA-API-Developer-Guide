---
title: OTA API Developer Guide

language_tabs: # must be one of https://git.io/vQNgJ
  - xml
  - shell
  - php
  - csharp
  - java


toc_footers:
  - <a href='http://www.weekendesk.fr' target='_blank'>Weekendesk Website</a>
  - <a href='http://partners.weekendesk.com' target='_blank'>Partner Extranet</a>
  - <a href='http://test-partners.weekendesk.com' target='_blank'>TEST - Partner Extranet</a>

includes:
  - errors

search: true
---

# Introduction

This document describes the interface specifications between the Weekendesk and a Channel Manager partner.<br>
The interface developed by the ChannelManager partner, according to the specifications present in this document, will allow a “2-ways” communication which will provide the following features:<br>

1. **ARI updates**: Availability&Restrictions, Rates and Inventory are received from ChannelManager partner and saved into Weekendesk inventory system
2. **Booking Notifications**: Reservations as soon as they are confirmed on Weekendesk front Website are PUSHed to the ChannelManager partner. When a reservation is cancelled a Cancellation notification is also PUSHed to the channel system.

Following this document, the Channel Manager partner can develop a web-service (client side) that will be compatible with Weekendesk inventory system (server side).

# OTA Standard

## Description

XML messages exchanged by the standard interface are based on standard Open Travel Alliance (OTA) 2003B.<br>
For further information on these standards, please consult:<br>

<b>OTA</b>:<a href='http://www.opentravel.org' target='blank'>http://www.opentravel.org</a><br>
<b>XMLSchema</b>:<a href='http://www.w3.org/2001/XMLSchema' target='blank'>http://www.w3.org/2001/XMLSchema</a>


## Messages

The standard interface of Weekendesk handles several cases based on the following OTA messages:

### OTA_Ping

The Ping RQ/RS allows the ChannelManager partner to test the connectivity is working.

### OTA_HotelRoomList

The RoomList RQ/RS is used by the ChannelManager partner to map the Weekendesk rooms and rate plans with the ones on its system.

### OTA_HotelAvailNotif

The Availability Notification RQ/RS allows the ChannelManager partner to send Availability, Restrictions and Booking Limits to Weekendesk for each rate plan mapped in its system.

### OTA_HotelRateAmountNotif

The Rates Amount Notification RQ/RS allows the ChannelManager partner to send prices for each rate that is mapped in its system.

#Setup

In this section it will be described all necessary steps to get your connectivity up and running.
<br>
Important things to remember before starting:
 <ul> - Every message will be exchanged on HTTP transport layer via HTTP POST method. </ul>
 <ul> - Request the credentials to your technical contact at Weekendesk in order to start making requests.</ul>
<ul> - A login and a password to connect to the Extranet may be requested and provided to the channel.</ul>

<aside class="success">
Remember - Before starting <b>send the list of IPs</b> and <b>the Endpoint for Reservation Delivery</b> you will be using both in testing and production to your technical contact at Weekendesk.
</aside>


## Authentication

> To authorize, use this code:

```xml
  Basic Auth user:password
```

```shell
  echo -n '102 iateasha' | base64
```

```php
$header = "Authorization: Basic " . base64_encode($username . ':' . $password);
```

```csharp
No command found
```

```java
No command found
```

> Make sure to replace `TEStTesttEsTt3st` with your Basic Authentication.

Weekendesk uses Basic Authentication to authenticate all requests. You can request your user and password at your technical point of contact in Weekendesk.

Weekendesk expects for the Basic Authentication to be included in all API requests to the server in a header that looks like the following:

`Authorization: Basic TEStTesttEsTt3st`

<aside class="notice">
You must replace <code>TEStTesttEsTt3st</code> with your user and password encrypted in base64_encode.
</aside>

##Testing the connectivity

This message is used to test that the connectivity is working, your IPs whitelisted and basic authentication you are using is correct.

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<?xml version="1.0" encoding="UTF-8"?>
<OTA_PingRQ Version="1.00" TimeStamp="2008-05-29T10:58:21">
</OTA_PingRQ>
```

```shell
curl
  -X POST
  -H "Content-Type: text/xml"
  -H "Authorization: Basic TEStTesttEsTt3st"
  -H "Cache-Control: no-cache"
  -d '<?xml version="1.0" encoding="UTF-8"?>
<OTA_PingRQ Version="1.0" TimeStamp="2008-05-29T10:58:21">
</OTA_PingRQ>' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('qualification-ari.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'authorization' => 'Basic TEStTesttEsTt3st',
  'content-type' => 'text/xml'
));

$request->setBody('<?xml version="1.0" encoding="UTF-8"?>
<OTA_PingRQ Version="1.0"" TimeStamp="2008-05-29T10:58:21">
</OTA_PingRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddHeader("content-type", "text/xml");
request.AddParameter("text/xml", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<OTA_PingRQ Version=\"1.01\" TimeStamp=\"2008-05-29T10:58:21\">\n</OTA_PingRQ>", ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<OTA_PingRQ Version=\"1.01\" TimeStamp=\"2008-05-29T10:58:21\">\n</OTA_PingRQ>");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("content-type", "text/xml")
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_PingRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="">
    <Success/>
</OTA_PingRS>
```

```shell
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_PingRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="">
    <Success/>
</OTA_PingRS>
```

```php
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_PingRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="">
    <Success/>
</OTA_PingRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_PingRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="">
    <Success/>
</OTA_PingRS>
```

```java
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_PingRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="">
    <Success/>
</OTA_PingRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/


#Retrieve Rooms

##Mapping

In order to start updating the information into the Weekendesk system you will have to map the IDs of the Room and RatePlans with the ones within your system.<br>
Weekendesk allows you to do that by using the OTA_HotelRoomList request which fetch all rooms and rate plans given a certain Weekendesk HotelID.

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRQ xmlns="http://www.opentravel.org/OTA/2003/05" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <POS>
    <Source>
       <RequestorID Type="1" ID="AL_TEST" />
    </Source>
 </POS>
 <HotelRoomLists>
    <HotelRoomList />
 </HotelRoomLists>
</OTA_HotelRoomListRQ>
```

```shell
curl
 -X POST
 -H "Content-Type: text/xml"
 -H "Authorization: Basic TEStTesttEsTt3st"
 -H "Cache-Control: no-cache"
 -d '<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRQ xmlns="http://www.opentravel.org/OTA/2003/05" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <POS>
    <Source>
       <RequestorID Type="1" ID="AL_TEST" />
    </Source>
 </POS>
 <HotelRoomLists>
    <HotelRoomList />
 </HotelRoomLists>
</OTA_HotelRoomListRQ>' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('https://ari.staging.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'authorization' => 'Basic TEStTesttEsTt3st',
  'content-type' => 'text/xml'
));

$request->setBody('<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRQ xmlns="http://www.opentravel.org/OTA/2003/05" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
   <POS>
      <Source>
         <RequestorID Type="1" ID="AL_TEST" />
      </Source>
   </POS>
   <HotelRoomLists>
      <HotelRoomList />
   </HotelRoomLists>
</OTA_HotelRoomListRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddHeader("content-type", "text/xml");
request.AddParameter("text/xml", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<OTA_HotelRoomListRQ xmlns=\"http://www.opentravel.org/OTA/2003/05\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\r\n   <POS>\r\n      <Source>\r\n         <RequestorID Type=\"1\" ID=\"AL_TEST\" />\r\n      </Source>\r\n   </POS>\r\n   <HotelRoomLists>\r\n      <HotelRoomList />\r\n   </HotelRoomLists>\r\n</OTA_HotelRoomListRQ>", ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<OTA_HotelRoomListRQ xmlns=\"http://www.opentravel.org/OTA/2003/05\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\r\n   <POS>\r\n      <Source>\r\n         <RequestorID Type=\"1\" ID=\"AL_TEST\" />\r\n      </Source>\r\n   </POS>\r\n   <HotelRoomLists>\r\n      <HotelRoomList />\r\n   </HotelRoomLists>\r\n</OTA_HotelRoomListRQ>");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("content-type", "text/xml")
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="2.0">
    <Success />
    <HotelRoomLists>
        <HotelRoomList HotelCode="AL_TEST">
            <RoomStays>
                <RoomStay>
                    <RoomTypes>
                        <RoomType IsRoom="true" RoomID="RO_TEST">
                            <RoomDescription Name="Test" />
                        </RoomType>
                    </RoomTypes>
                    <RatePlans>
                        <RatePlan RatePlanName="BAR" RatePlanID="001" />
                        <RatePlan RatePlanName="SALE" RatePlanID="003" />
                    </RatePlans>
                </RoomStay>
            </RoomStays>
        </HotelRoomList>
    </HotelRoomLists>
</OTA_HotelRoomListRS>
```

```shell
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="2.0">
    <Success />
    <HotelRoomLists>
        <HotelRoomList HotelCode="AL_TEST">
            <RoomStays>
                <RoomStay>
                    <RoomTypes>
                        <RoomType IsRoom="true" RoomID="RO_TEST">
                            <RoomDescription Name="Test" />
                        </RoomType>
                    </RoomTypes>
                    <RatePlans>
                        <RatePlan RatePlanName="BAR" RatePlanID="001" />
                        <RatePlan RatePlanName="SALE" RatePlanID="003" />
                    </RatePlans>
                </RoomStay>
            </RoomStays>
        </HotelRoomList>
    </HotelRoomLists>
</OTA_HotelRoomListRS>
```

```php
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="2.0">
    <Success />
    <HotelRoomLists>
        <HotelRoomList HotelCode="AL_TEST">
            <RoomStays>
                <RoomStay>
                    <RoomTypes>
                        <RoomType IsRoom="true" RoomID="RO_TEST">
                            <RoomDescription Name="Test" />
                        </RoomType>
                    </RoomTypes>
                    <RatePlans>
                        <RatePlan RatePlanName="BAR" RatePlanID="001" />
                        <RatePlan RatePlanName="SALE" RatePlanID="003" />
                    </RatePlans>
                </RoomStay>
            </RoomStays>
        </HotelRoomList>
    </HotelRoomLists>
</OTA_HotelRoomListRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="2.0">
    <Success />
    <HotelRoomLists>
        <HotelRoomList HotelCode="AL_TEST">
            <RoomStays>
                <RoomStay>
                    <RoomTypes>
                        <RoomType IsRoom="true" RoomID="RO_TEST">
                            <RoomDescription Name="Test" />
                        </RoomType>
                    </RoomTypes>
                    <RatePlans>
                        <RatePlan RatePlanName="BAR" RatePlanID="001" />
                        <RatePlan RatePlanName="SALE" RatePlanID="003" />
                    </RatePlans>
                </RoomStay>
            </RoomStays>
        </HotelRoomList>
    </HotelRoomLists>
</OTA_HotelRoomListRS>
```

```java
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRoomListRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="2.0">
    <Success />
    <HotelRoomLists>
        <HotelRoomList HotelCode="AL_TEST">
            <RoomStays>
                <RoomStay>
                    <RoomTypes>
                        <RoomType IsRoom="true" RoomID="RO_TEST">
                            <RoomDescription Name="Test" />
                        </RoomType>
                    </RoomTypes>
                    <RatePlans>
                        <RatePlan RatePlanName="BAR" RatePlanID="001" />
                        <RatePlan RatePlanName="SALE" RatePlanID="003" />
                    </RatePlans>
                </RoomStay>
            </RoomStays>
        </HotelRoomList>
    </HotelRoomLists>
</OTA_HotelRoomListRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Type | integer | Yes | Always use Type=1 for Hotels
ID | string | Yes | Weekendesk Hotel ID


# ARI Updates

The updates of Availability, Rates and Inventory are performed by the ChannelManager partner to Weekendesk system.<br>Data receive via these updates are reflected in the product displayed on the front which are updated consequently.<br>
In details<br>
- The <b> OTA_HotelAvailNotifRQ </b> handles Availability, Restrictions and Inventory<br>
- The <b> OTA_HotelRateAmountNotifRQ </b> handles the prices for each Rate

## Update Availability

The ChannelManager partner can Open or Close the availability of any RatePlan of any Room mapped with Weekendesk. Once Closed, the RatePlan will not be available for sale on the Website and Applications.

<aside class="success">
Remember - The Availability is per RatePlan. If your Room has more than one RatePlan <b>only the RatePlan that is specified in the request</b> will be Closed (or Opened).
</aside>

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-24T23:00:26" Target="Production">
   	<AvailStatusMessages HotelCode="AL_TEST">
      <AvailStatusMessage LocatorID="1">
         <StatusApplicationControl Start="2017-09-01" End="2017-09-02"
         RatePlanCode="003" InvTypeCode="RO_TEST" />
         <RestrictionStatus Status="Open" />
      </AvailStatusMessage>
    </AvailStatusMessages>
</OTA_HotelAvailNotifRQ>
```

```shell
curl -X POST
-H "Authorization: Basic TEStTesttEsTt3st"
-H "Content-Type: text/xml" -H "Cache-Control: no-cache"
-d '<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-24T23:00:26" Target="Production">
   <AvailStatusMessages HotelCode="AL_TEST">
      <AvailStatusMessage LocatorID="1">
         <StatusApplicationControl Start="2017-09-01" End="2017-09-02" RatePlanCode="003" InvTypeCode="RO_TEST" />
         <RestrictionStatus Status="Open" />
      </AvailStatusMessage>
   </AvailStatusMessages>
</OTA_HotelAvailNotifRQ>
' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('https://ari.staging.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'content-type' => 'text/xml',
  'authorization' => 'Basic TEStTesttEsTt3st'
));

$request->setBody('<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-24T23:00:26" Target="Production">
   <AvailStatusMessages HotelCode="AL_TEST">
      <AvailStatusMessage LocatorID="1">
         <StatusApplicationControl Start="2017-09-01" End="2017-09-02"
         RatePlanCode="003" InvTypeCode="RO_TEST" />
         <RestrictionStatus Status="Open" />
      </AvailStatusMessage>
   </AvailStatusMessages>
</OTA_HotelAvailNotifRQ>
');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("content-type", "text/xml");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddParameter("text/xml", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n
<OTA_HotelAvailNotifRQ xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\"
TimeStamp=\"2016-02-24T23:00:26\" Target=\"Production\">\r\n  
\t<AvailStatusMessages HotelCode=\"AL_TEST\">\r\n      
<AvailStatusMessage LocatorID=\"1\">\r\n         
<StatusApplicationControl Start=\"2017-09-01\" End=\"2017-09-02\"
RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\r\n         
<RestrictionStatus Status=\"Open\" />\r\n      
</AvailStatusMessage>\r\n   
</AvailStatusMessages>\r\n</OTA_HotelAvailNotifRQ>\r\n", ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType,
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n
<OTA_HotelAvailNotifRQ xmlns=\"http://www.opentravel.org/OTA/2003/05\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\" TimeStamp=\"2016-02-24T23:00:26\" Target=\"Production\">\r\n   \t<AvailStatusMessages HotelCode=\"AL_TEST\">\r\n      
<AvailStatusMessage LocatorID=\"1\">\r\n         
<StatusApplicationControl Start=\"2018-09-01\" End=\"2018-09-02\"
RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\r\n         
<RestrictionStatus Status=\"Open\" />\r\n      
</AvailStatusMessage>\r\n    
</AvailStatusMessages>\r\n
</OTA_HotelAvailNotifRQ>\r\n");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("content-type", "text/xml")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```shell
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>```

```php
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```java
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Version | string | Yes | 1.0 is the latest version
TimeStamp | date | Yes | TimeStamp of the request (YYY-MM-DD-THH:MM:SS)
Target | string | Yes | Testing=Test environment; Production=Prod environment
HotelCode | string | Yes | The Weekendesk Hotel ID
LocatorID | integer | Yes | Progressive number based on the number of AvailStatusMessage tag within the same request
Start | date | Yes | Starting date of the updated period (YYY-MM-DD). The Start date is included in the updated period.
End | date | Yes | Ending date of the updated period (YYY-MM-DD). The End date is included in the updated period.
RatePlanCode | string | Yes | Code of the Rate Plan for which the update is sent
InvTypeCode | string | Yes | Code of the Room for which the update is sent
Status | string | No | Open=The rate plan is sellable; Close=Stop sale

##Update Restrictions

Weekendesk handles several types of restrictions.
<br><br>
- MinStay (Minimum Stay Through)<br>
- MaxStay (Maximum Stay Through)<br>
- CTA (Close to Arrival)<br>
- CTD (Close to Departure)<br>
<br>Each of the these restrictions can be sent in the same request and/or combined with Availability and Inventory updates.

<aside class="success">
Remember - The ChannelManager partner may decide not to send one or more restrictions. If this happens, no update will be made for this restriction.
</aside>


```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
	   <AvailStatusMessages HotelCode="AL_TEST">
	      <AvailStatusMessage LocatorID="1">
	         <StatusApplicationControl Start="2017-02-27" End="2017-02-27"
           RatePlanCode="003" InvTypeCode="RO_TEST" />
	         <LengthsOfStay>
	            <LengthOfStay Time="3" MinMaxMessageType="SetMinLOS" />
	            <LengthOfStay Time="11" MinMaxMessageType="SetMaxLOS" />
	         </LengthsOfStay>
	         <RestrictionStatus Restriction="Arrival" Status="Open" />
	         <RestrictionStatus Restriction="Departure" Status="Open" />
	      </AvailStatusMessage>
	   </AvailStatusMessages>
	</OTA_HotelAvailNotifRQ>
```

```shell
curl
  -X POST
  -H "Content-Type: text/xml"
  -H "Authorization: Basic TEStTesttEsTt3st"
  -H "Cache-Control: no-cache"
  -d '<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
	   <AvailStatusMessages HotelCode="AL_TEST">
	      <AvailStatusMessage LocatorID="1">
	         <StatusApplicationControl Start="2017-02-27" End="2017-02-27"
           RatePlanCode="003" InvTypeCode="RO_TEST" />
	         <LengthsOfStay>
	            <LengthOfStay Time="3" MinMaxMessageType="SetMinLOS" />
	            <LengthOfStay Time="11" MinMaxMessageType="SetMaxLOS" />
	         </LengthsOfStay>
	         <RestrictionStatus Restriction="Arrival" Status="Open" />
	         <RestrictionStatus Restriction="Departure" Status="Open" />
	      </AvailStatusMessage>
	   </AvailStatusMessages>
	</OTA_HotelAvailNotifRQ>' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('qualification-ari.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'authorization' => 'Basic TEStTesttEsTt3st',
  'content-type' => 'text/xml'
));

$request->setBody('<OTA_HotelAvailNotifRQ
xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
	   <AvailStatusMessages HotelCode="AL_TEST">
	      <AvailStatusMessage LocatorID="1">
	         <StatusApplicationControl Start="2017-02-27" End="2017-02-27"
           RatePlanCode="003" InvTypeCode="RO_TEST" />
	         <LengthsOfStay>
	            <LengthOfStay Time="3" MinMaxMessageType="SetMinLOS" />
	            <LengthOfStay Time="11" MinMaxMessageType="SetMaxLOS" />
	         </LengthsOfStay>
	         <RestrictionStatus Restriction="Arrival" Status="Open" />
	         <RestrictionStatus Restriction="Departure" Status="Open" />
	      </AvailStatusMessage>
	   </AvailStatusMessages>
	</OTA_HotelAvailNotifRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddHeader("content-type", "text/xml");
request.AddParameter("text/xml", "<OTA_HotelAvailNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\"
TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\n\t   <AvailStatusMessages
HotelCode=\"AL_TEST\">\n\t      <AvailStatusMessage LocatorID=\"1\">\n\t        
<StatusApplicationControl Start=\"2017-02-27\" End=\"2017-02-27\"
RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\n\t       
<LengthsOfStay>\n\t            <LengthOfStay Time=\"3\"
MinMaxMessageType=\"SetMinLOS\" />\n\t            <LengthOfStay Time=\"11\"
MinMaxMessageType=\"SetMaxLOS\" />\n\t         </LengthsOfStay>\n\t        
<RestrictionStatus Restriction=\"Arrival\" Status=\"Open\" />\n\t        
<RestrictionStatus Restriction=\"Departure\" Status=\"Open\" />\n\t     
</AvailStatusMessage>\n\t   </AvailStatusMessages>\n\t</OTA_HotelAvailNotifRQ>",
ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<OTA_HotelAvailNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\"
TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\n\t   <AvailStatusMessages
HotelCode=\"AL_TEST\">\n\t      <AvailStatusMessage LocatorID=\"1\">\n\t        
<StatusApplicationControl Start=\"2017-02-27\" End=\"2017-02-27\"
RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\n\t        
<LengthsOfStay>\n\t            <LengthOfStay Time=\"3\"
MinMaxMessageType=\"SetMinLOS\" />\n\t            <LengthOfStay Time=\"11\"
MinMaxMessageType=\"SetMaxLOS\" />\n\t         </LengthsOfStay>\n\t        
<RestrictionStatus Restriction=\"Arrival\" Status=\"Open\" />\n\t        
<RestrictionStatus Restriction=\"Departure\" Status=\"Open\" />\n\t     
</AvailStatusMessage>\n\t   </AvailStatusMessages>\n\t</OTA_HotelAvailNotifRQ>");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("content-type", "text/xml")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```shell
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```php
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```java
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```


### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Version | string | Yes | 1.0 is the latest version
TimeStamp | date | Yes | TimeStamp of the request (YYY-MM-DD-THH:MM:SS)
Target | string | Yes | Testing=Test environment; Production=Prod environment
HotelCode | string | Yes | The Weekendesk Hotel ID
LocatorID | integer | Yes | Progressive number based on the number of AvailStatusMessage tag within the same request
Start | date | Yes | Starting date of the updated period (YYY-MM-DD). The Start date is included in the updated period.
End | date | Yes | Ending date of the updated period (YYY-MM-DD). The End date is included in the updated period.
RatePlanCode | string | Yes | Code of the Rate Plan for which the update is sent
InvTypeCode | string | Yes | Code of the Room for which the update is sent
Time | integer | No | Defines the Minimum (or Maximum) number of days of Stay required for a specific Rate Plan
MinMaxMessageType | string | No | SetMinLOS=updates the MinStay restriction; SetMaxLOS=updates the MaxStay restriction
Restriction | string | No | Arrival=updates the CTA restriction; Departure=updates the CTD restriction
Status | string | No | Open=The rate plan is sellable. If the Restriction tag is present it indicates that CheckIn (or CheckOut) is Open for that day; Close=Stop sale. If the Restriction tag is present it indicates a CloseToArrival (or CloseToDeparture) on that day.

##Update Inventory

Weekendesk supports the Inventory at the RatePlan level. The ChannelManager partner can either send the same value for all RatePlans or a different value for each RatePlan.
<br>
If the ChannelManager partner handles the stock at the room level, is supposed to send the same value for all RatePlans, and update the same for all RatePlans when receiving a new reservation.

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
	   <AvailStatusMessages HotelCode="AL_TEST">
	      <AvailStatusMessage BookingLimit="10" LocatorID="1">
	         <StatusApplicationControl Start="2017-02-27" End="2017-02-27"
           RatePlanCode="003" InvTypeCode="RO_TEST" />
	      </AvailStatusMessage>
	   </AvailStatusMessages>
	</OTA_HotelAvailNotifRQ>
```

```shell
curl
-X POST
-H "Authorization: Basic TEStTesttEsTt3st"
-H "Content-Type: text/xml"
-H "Cache-Control: no-cache"
-d '<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
	   <AvailStatusMessages HotelCode="AL_TEST">
	      <AvailStatusMessage BookingLimit="10" LocatorID="1">
	         <StatusApplicationControl Start="2017-02-27" End="2017-02-27"
           RatePlanCode="003" InvTypeCode="RO_TEST" />
	      </AvailStatusMessage>
	   </AvailStatusMessages>
	</OTA_HotelAvailNotifRQ>' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('https://ari.staging.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'content-type' => 'text/xml',
  'authorization' => 'Basic TEStTesttEsTt3st'
));

$request->setBody('<OTA_HotelAvailNotifRQ
xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
	   <AvailStatusMessages HotelCode="AL_TEST">
	      <AvailStatusMessage BookingLimit="10" LocatorID="1">
	         <StatusApplicationControl Start="2017-02-27" End="2017-02-27"
           RatePlanCode="003" InvTypeCode="RO_TEST" />
	      </AvailStatusMessage>
	   </AvailStatusMessages>
	</OTA_HotelAvailNotifRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("content-type", "text/xml");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddParameter("text/xml", "<OTA_HotelAvailNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\"
TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\n\t   <AvailStatusMessages
HotelCode=\"AL_TEST\">\n\t      <AvailStatusMessage BookingLimit=\"10\"
LocatorID=\"1\">\n\t         <StatusApplicationControl Start=\"2017-02-27\"
End=\"2017-02-27\" RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\n\t     
</AvailStatusMessage>\n\t   </AvailStatusMessages>\n\t</OTA_HotelAvailNotifRQ>",
ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<OTA_HotelAvailNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\"
TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\n\t   <AvailStatusMessages
HotelCode=\"AL_TEST\">\n\t      <AvailStatusMessage BookingLimit=\"10\"
LocatorID=\"1\">\n\t         <StatusApplicationControl Start=\"2017-02-27\"
End=\"2017-02-27\" RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\n\t     
</AvailStatusMessage>\n\t   </AvailStatusMessages>\n\t</OTA_HotelAvailNotifRQ>");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("content-type", "text/xml")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```shell
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```php
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```java
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Version | string | Yes | 1.0 is the latest version
TimeStamp | date | Yes | TimeStamp of the request (YYY-MM-DD-THH:MM:SS)
Target | string | Yes | Testing=Test environment; Production=Prod environment
HotelCode | string | Yes | The Weekendesk Hotel ID
LocatorID | integer | Yes | Progressive number based on the number of AvailStatusMessage tag within the same request
Start | date | Yes | Starting date of the updated period (YYY-MM-DD). The Start date is included in the updated period.
End | date | Yes | Ending date of the updated period (YYY-MM-DD). The End date is included in the updated period.
RatePlanCode | string | Yes | Code of the Rate Plan for which the update is sent
InvTypeCode | string | Yes | Code of the Room for which the update is sent
BookingLimit | integer | No | Defines the number of Stock available for a specific Rate Plan

##Multiple Updates
(Availability, Restrictions, Inventory)

The ChannelManager partner can combine multiple updates of availability, restrictions and inventory in the same request, for different room and rates, specifying each section with a <b>different LocatorID</b>s.
<br>
<aside class="warning">We highly recommend to use multiple updates only for short periods in order to avoid service disruptions. Weekendesk reserves the right of restricting the number of requests per minute if noticed a high usage of this type of request</aside>

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
   <AvailStatusMessages HotelCode="AL_TEST">
      <AvailStatusMessage BookingLimit="29" LocatorID="1">
         <StatusApplicationControl Start="2017-04-23" End="2017-04-30"
         RatePlanCode="001" InvTypeCode="RO_TEST" />
         <LengthsOfStay>
            <LengthOfStay Time="2" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Close" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Open" />
      </AvailStatusMessage>
      <AvailStatusMessage BookingLimit="20" LocatorID="2">
         <StatusApplicationControl Start="2017-03-23" End="2017-03-30"
         RatePlanCode="003" InvTypeCode="RO_TEST" />
         <LengthsOfStay>
            <LengthOfStay Time="1" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Open" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Close" />
      </AvailStatusMessage>
      <AvailStatusMessage BookingLimit="20" LocatorID="3">
         <StatusApplicationControl Start="2017-03-23" End="2017-03-30"
         RatePlanCode="003" InvTypeCode="RO_TEST2" />
         <LengthsOfStay>
            <LengthOfStay Time="3" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Open" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Open" />
      </AvailStatusMessage>
   </AvailStatusMessages>
</OTA_HotelAvailNotifRQ>
```

```shell
curl
-X POST
-H "Authorization: Basic TEStTesttEsTt3st"
-H "Content-Type: text/xml"
-H "Cache-Control: no-cache"
-d '<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
   <AvailStatusMessages HotelCode="AL_TEST">
      <AvailStatusMessage BookingLimit="29" LocatorID="1">
         <StatusApplicationControl Start="2017-04-23" End="2017-04-30"
         RatePlanCode="001" InvTypeCode="RO_TEST" />
         <LengthsOfStay>
            <LengthOfStay Time="2" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Close" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Open" />
      </AvailStatusMessage>
      <AvailStatusMessage BookingLimit="20" LocatorID="2">
         <StatusApplicationControl Start="2017-03-23" End="2017-03-30"
         RatePlanCode="003" InvTypeCode="RO_TEST" />
         <LengthsOfStay>
            <LengthOfStay Time="1" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Open" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Close" />
      </AvailStatusMessage>
      <AvailStatusMessage BookingLimit="20" LocatorID="3">
         <StatusApplicationControl Start="2017-03-23" End="2017-03-30"
         RatePlanCode="003" InvTypeCode="RO_TEST2" />
         <LengthsOfStay>
            <LengthOfStay Time="3" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Open" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Open" />
      </AvailStatusMessage>
   </AvailStatusMessages>
</OTA_HotelAvailNotifRQ>' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('https://ari.staging.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'content-type' => 'text/xml',
  'authorization' => 'Basic TEStTesttEsTt3st'
));

$request->setBody('<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
TimeStamp="2016-02-26T10:32:51" Target="Production">
   <AvailStatusMessages HotelCode="AL_TEST">
      <AvailStatusMessage BookingLimit="29" LocatorID="1">
         <StatusApplicationControl Start="2017-04-23" End="2017-04-30"
         RatePlanCode="001" InvTypeCode="RO_TEST" />
         <LengthsOfStay>
            <LengthOfStay Time="2" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Close" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Open" />
      </AvailStatusMessage>
      <AvailStatusMessage BookingLimit="20" LocatorID="2">
         <StatusApplicationControl Start="2017-03-23" End="2017-03-30"
         RatePlanCode="003" InvTypeCode="RO_TEST" />
         <LengthsOfStay>
            <LengthOfStay Time="1" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Open" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Close" />
      </AvailStatusMessage>
      <AvailStatusMessage BookingLimit="20" LocatorID="3">
         <StatusApplicationControl Start="2017-03-23" End="2017-03-30"
         RatePlanCode="003" InvTypeCode="RO_TEST2" />
         <LengthsOfStay>
            <LengthOfStay Time="3" MinMaxMessageType="SetMinLOS" />
            <LengthOfStay Time="99" MinMaxMessageType="SetMaxLOS" />
         </LengthsOfStay>
         <RestrictionStatus Status="Open" />
         <RestrictionStatus Restriction="Arrival" Status="Open" />
         <RestrictionStatus Restriction="Departure" Status="Open" />
      </AvailStatusMessage>
   </AvailStatusMessages>
</OTA_HotelAvailNotifRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("content-type", "text/xml");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddParameter("text/xml", "<?xml version=\"1.0\"
encoding=\"UTF-8\"?>\r\n<OTA_HotelAvailNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\"
TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\r\n   <AvailStatusMessages
HotelCode=\"AL_TEST\">\r\n      <AvailStatusMessage BookingLimit=\"29\"
LocatorID=\"1\">\r\n         <StatusApplicationControl Start=\"2017-04-23\"
End=\"2017-04-30\" RatePlanCode=\"001\" InvTypeCode=\"RO_TEST\" />\r\n        
<LengthsOfStay>\r\n            <LengthOfStay Time=\"2\"
MinMaxMessageType=\"SetMinLOS\" />\r\n            <LengthOfStay Time=\"99\"
MinMaxMessageType=\"SetMaxLOS\" />\r\n         </LengthsOfStay>\r\n        
<RestrictionStatus Status=\"Close\" />\r\n         <RestrictionStatus
Restriction=\"Arrival\" Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Departure\" Status=\"Open\" />\r\n      </AvailStatusMessage>\r\n     
<AvailStatusMessage BookingLimit=\"20\" LocatorID=\"2\">\r\n        
<StatusApplicationControl Start=\"2017-03-23\" End=\"2017-03-30\"
RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\r\n        
<LengthsOfStay>\r\n            <LengthOfStay Time=\"1\"
MinMaxMessageType=\"SetMinLOS\" />\r\n            <LengthOfStay Time=\"99\"
MinMaxMessageType=\"SetMaxLOS\" />\r\n         </LengthsOfStay>\r\n        
<RestrictionStatus Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Arrival\" Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Departure\" Status=\"Close\" />\r\n     
</AvailStatusMessage>\r\n      <AvailStatusMessage BookingLimit=\"20\"
LocatorID=\"3\">\r\n         <StatusApplicationControl Start=\"2017-03-23\"
End=\"2017-03-30\" RatePlanCode=\"003\" InvTypeCode=\"RO_TEST2\" />\r\n        
<LengthsOfStay>\r\n            <LengthOfStay Time=\"3\"
MinMaxMessageType=\"SetMinLOS\" />\r\n            <LengthOfStay Time=\"99\"
MinMaxMessageType=\"SetMaxLOS\" />\r\n         </LengthsOfStay>\r\n        
<RestrictionStatus Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Arrival\" Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Departure\" Status=\"Open\" />\r\n      </AvailStatusMessage>\r\n  
</AvailStatusMessages>\r\n</OTA_HotelAvailNotifRQ>", ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<?xml version=\"1.0\"
encoding=\"UTF-8\"?>\r\n<OTA_HotelAvailNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Version=\"1\"
TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\r\n   <AvailStatusMessages
HotelCode=\"AL_TEST\">\r\n      <AvailStatusMessage BookingLimit=\"29\"
LocatorID=\"1\">\r\n         <StatusApplicationControl Start=\"2017-04-23\"
End=\"2017-04-30\" RatePlanCode=\"001\" InvTypeCode=\"RO_TEST\" />\r\n        
<LengthsOfStay>\r\n            <LengthOfStay Time=\"2\"
MinMaxMessageType=\"SetMinLOS\" />\r\n            <LengthOfStay Time=\"99\"
MinMaxMessageType=\"SetMaxLOS\" />\r\n         </LengthsOfStay>\r\n        
<RestrictionStatus Status=\"Close\" />\r\n         <RestrictionStatus
Restriction=\"Arrival\" Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Departure\" Status=\"Open\" />\r\n      </AvailStatusMessage>\r\n     
<AvailStatusMessage BookingLimit=\"20\" LocatorID=\"2\">\r\n        
<StatusApplicationControl Start=\"2017-03-23\" End=\"2017-03-30\"
RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\" />\r\n        
<LengthsOfStay>\r\n            <LengthOfStay Time=\"1\"
MinMaxMessageType=\"SetMinLOS\" />\r\n            <LengthOfStay Time=\"99\"
MinMaxMessageType=\"SetMaxLOS\" />\r\n         </LengthsOfStay>\r\n        
<RestrictionStatus Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Arrival\" Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Departure\" Status=\"Close\" />\r\n     
</AvailStatusMessage>\r\n      <AvailStatusMessage BookingLimit=\"20\"
LocatorID=\"3\">\r\n         <StatusApplicationControl Start=\"2017-03-23\"
End=\"2017-03-30\" RatePlanCode=\"003\" InvTypeCode=\"RO_TEST2\" />\r\n        
<LengthsOfStay>\r\n            <LengthOfStay Time=\"3\"
MinMaxMessageType=\"SetMinLOS\" />\r\n            <LengthOfStay Time=\"99\"
MinMaxMessageType=\"SetMaxLOS\" />\r\n         </LengthsOfStay>\r\n      
<RestrictionStatus Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Arrival\" Status=\"Open\" />\r\n         <RestrictionStatus
Restriction=\"Departure\" Status=\"Open\" />\r\n      </AvailStatusMessage>\r\n  
</AvailStatusMessages>\r\n</OTA_HotelAvailNotifRQ>");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("content-type", "text/xml")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```shell
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```php
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

```java
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-26T10:32:51" Target="Production">
    <Success />
</OTA_HotelAvailNotifRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Version | string | Yes | 1.0 is the latest version
TimeStamp | date | Yes | TimeStamp of the request (YYY-MM-DD-THH:MM:SS)
Target | string | Yes | Testing=Test environment; Production=Prod environment
HotelCode | string | Yes | The Weekendesk Hotel ID
LocatorID | integer | Yes | Progressive number based on the number of AvailStatusMessage tag within the same request
Start | date | Yes | Starting date of the updated period (YYY-MM-DD). The Start date is included in the updated period.
End | date | Yes | Ending date of the updated period (YYY-MM-DD). The End date is included in the updated period.
RatePlanCode | string | Yes | Code of the Rate Plan for which the update is sent
InvTypeCode | string | Yes | Code of the Room for which the update is sent
BookingLimit | integer | No | Defines the number of Stock available for a specific Rate Plan
Time | integer | No | Defines the Minimum (or Maximum) number of days of Stay required for a specific Rate Plan
MinMaxMessageType | string | No | SetMinLOS=updates the MinStay restriction; SetMaxLOS=updates the MaxStay restriction
Restriction | string | No | Arrival=updates the CTA restriction; Departure=updates the CTD restriction
Status | string | No | Open=The rate plan is sellable. If the Restriction tag is present it indicates that CheckIn (or CheckOut) is Open for that day; Close=Stop sale. If the Restriction tag is present it indicates a CloseToArrival (or CloseToDeparture) on that day.


##Update Rates

In order to update Rates of a specific RatePlan use the following OTA request:
<br>
OTA_HotelRateAmountNotifRQ
<br>
The update can be sent for a specific RatePlanCode of a Hotel Room for a specific period.

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<OTA_HotelRateAmountNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    Version="1" TimeStamp="2013-07-19T10:03:09" Target="Production">
    <RateAmountMessages HotelCode="AL_TEST">
        <RateAmountMessage LocatorID="1">
            <StatusApplicationControl Start="2017-02-23" End="2017-03-30"
            RatePlanCode="001" InvTypeCode="RO_TEST" />
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AmountAfterTax="200.00" DecimalPlaces="0" />
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RateAmountMessage>
        <RateAmountMessage LocatorID="2">
            <StatusApplicationControl Start="2017-02-20" End="2017-03-30"
            RatePlanCode="003" InvTypeCode="RO_TEST" />
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AmountAfterTax="100.00" DecimalPlaces="0" />
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RateAmountMessage>
    </RateAmountMessages>
</OTA_HotelRateAmountNotifRQ>
```

```shell
curl
-X POST
-H "Authorization: Basic TEStTesttEsTt3st"
-H "Content-Type: text/xml"
-H "Cache-Control: no-cache"
-d '<OTA_HotelRateAmountNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    Version="1" TimeStamp="2013-07-19T10:03:09" Target="Production">
    <RateAmountMessages HotelCode="AL_TEST">
        <RateAmountMessage LocatorID="1">
            <StatusApplicationControl Start="2017-02-23" End="2017-03-30"
            RatePlanCode="001" InvTypeCode="RO_TEST" />
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AmountAfterTax="200.00" DecimalPlaces="0" />
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RateAmountMessage>
        <RateAmountMessage LocatorID="2">
            <StatusApplicationControl Start="2017-02-20" End="2017-03-30"
            RatePlanCode="003" InvTypeCode="RO_TEST" />
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AmountAfterTax="100.00" DecimalPlaces="0" />
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RateAmountMessage>
    </RateAmountMessages>
</OTA_HotelRateAmountNotifRQ>' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('https://ari.staging.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'content-type' => 'text/xml',
  'authorization' => 'Basic TEStTesttEsTt3st'
));

$request->setBody('<OTA_HotelRateAmountNotifRQ xmlns="http://www.opentravel.org/OTA/2003/05"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    Version="1" TimeStamp="2013-07-19T10:03:09" Target="Production">
    <RateAmountMessages HotelCode="AL_TEST">
        <RateAmountMessage LocatorID="1">
            <StatusApplicationControl Start="2017-02-23" End="2017-03-30"
            RatePlanCode="001" InvTypeCode="RO_TEST" />
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AmountAfterTax="200.00" DecimalPlaces="0" />
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RateAmountMessage>
        <RateAmountMessage LocatorID="2">
            <StatusApplicationControl Start="2017-02-20" End="2017-03-30"
            RatePlanCode="003" InvTypeCode="RO_TEST" />
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AmountAfterTax="100.00" DecimalPlaces="0" />
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RateAmountMessage>
    </RateAmountMessages>
</OTA_HotelRateAmountNotifRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("content-type", "text/xml");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddParameter("text/xml", "<OTA_HotelRateAmountNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"\n   
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n    Version=\"1\"
TimeStamp=\"2013-07-19T10:03:09\" Target=\"Production\">\n    <RateAmountMessages
HotelCode=\"AL_TEST\">\n        <RateAmountMessage LocatorID=\"1\">\n           
<StatusApplicationControl Start=\"2017-02-23\" End=\"2017-03-30\"
RatePlanCode=\"001\" InvTypeCode=\"RO_TEST\" />\n           
<Rates>\n                <Rate>\n                   
<BaseByGuestAmts>\n                        <BaseByGuestAmt AmountAfterTax=\"200.00\"
DecimalPlaces=\"0\" />\n                    </BaseByGuestAmts>\n               
</Rate>\n            </Rates>\n        </RateAmountMessage>\n       
<RateAmountMessage LocatorID=\"2\">\n            <StatusApplicationControl
Start=\"2017-02-20\" End=\"2017-03-30\" RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\"
/>\n            <Rates>\n                <Rate>\n                   
<BaseByGuestAmts>\n                        <BaseByGuestAmt AmountAfterTax=\"100.00\"
DecimalPlaces=\"0\" />\n                    </BaseByGuestAmts>\n               
</Rate>\n            </Rates>\n        </RateAmountMessage>\n   
</RateAmountMessages>\n</OTA_HotelRateAmountNotifRQ>", ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<OTA_HotelRateAmountNotifRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"\n   
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n    Version=\"1\"
TimeStamp=\"2013-07-19T10:03:09\" Target=\"Production\">\n    <RateAmountMessages
HotelCode=\"AL_TEST\">\n        <RateAmountMessage LocatorID=\"1\">\n           
<StatusApplicationControl Start=\"2017-02-23\" End=\"2017-03-30\"
RatePlanCode=\"001\" InvTypeCode=\"RO_TEST\" />\n           
<Rates>\n                <Rate>\n                   
<BaseByGuestAmts>\n                        <BaseByGuestAmt AmountAfterTax=\"200.00\"
DecimalPlaces=\"0\" />\n                    </BaseByGuestAmts>\n               
</Rate>\n            </Rates>\n        </RateAmountMessage>\n     
<RateAmountMessage LocatorID=\"2\">\n            <StatusApplicationControl
Start=\"2017-02-20\" End=\"2017-03-30\" RatePlanCode=\"003\" InvTypeCode=\"RO_TEST\"
/>\n            <Rates>\n                <Rate>\n                   
<BaseByGuestAmts>\n                        <BaseByGuestAmt AmountAfterTax=\"100.00\"
DecimalPlaces=\"0\" />\n                    </BaseByGuestAmts>\n               
</Rate>\n            </Rates>\n        </RateAmountMessage>\n   
</RateAmountMessages>\n</OTA_HotelRateAmountNotifRQ>");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("content-type", "text/xml")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRateAmountNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelRateAmountNotifRS>
```

```shell
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRateAmountNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelRateAmountNotifRS>
```

```php
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRateAmountNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelRateAmountNotifRS>```

```csharp
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRateAmountNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelRateAmountNotifRS>
```

```java
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRateAmountNotifRS xmlns="http://www.opentravel.org/OTA/2003/05"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1"
  TimeStamp="2016-02-24T23:00:26" Target="Production">
    <Success />
</OTA_HotelRateAmountNotifRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Version | string | Yes | 1.0 is the latest version
TimeStamp | date | Yes | TimeStamp of the request (YYY-MM-DD-THH:MM:SS)
Target | string | Yes | Testing=Test environment; Production=Prod environment
HotelCode | string | Yes | The Weekendesk Hotel ID
LocatorID | integer | Yes | Progressive number based on the number of AvailStatusMessage tag within the same request
Start | date | Yes | Starting date of the updated period (YYY-MM-DD). The Start date is included in the updated period.
End | date | Yes | Ending date of the updated period (YYY-MM-DD). The End date is included in the updated period.
RatePlanCode | string | Yes | Code of the Rate Plan for which the update is sent
InvTypeCode | string | Yes | Code of the Room for which the update is sent
AmountAfterTax | decimal | Yes | The price for the Rate of a specific Rate Plan
DecimalPlaces | integer | No | Number of decimal places used in the AmountAfterTax

#ARI Read

The Reading function allows the ChannelManager partner to retrieve prices and availabilities for a given Room and RatePlan code.

##Read Availabilities

The AvailGet request allows the ChannelManager partner to request availabilities for a specific Room and RatePlan. The following information will be given: <br>
<br>
- Booking Limit<br>
- Min LengthOfStay<br>
- Max LengthOfStay<br>
- Closed to Arrival<br>
- Closed to Departure<br>
<br>
<aside class="notice">
Remember, due to performance constraints <code>only one data range is allowed</code> within the same request.
</aside>

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailGetRQ xmlns="http://www.opentravel.org/OTA/2003/05" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     Version="1.0" TimeStamp="2016-02-26T10:32:51" Target="Production">
    <HotelAvailRequests HotelCode="AL_TEST">
        <HotelAvailRequest>
            <DateRange Start="2017-03-23" End="2017-03-25"/>
            <RatePlans>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="003"/>
            </RatePlans>
        </HotelAvailRequest>
    </HotelAvailRequests>
</OTA_HotelAvailGetRQ>
```

```shell
curl
-X POST
-H "Authorization: Basic TEStTesttEsTt3st"
-H "Content-Type: text/xml"
-H "Cache-Control: no-cache"
-d '<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailGetRQ xmlns="http://www.opentravel.org/OTA/2003/05" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     Version="1.0" TimeStamp="2016-02-26T10:32:51" Target="Production">
    <HotelAvailRequests HotelCode="AL_TEST">
        <HotelAvailRequest>
            <DateRange Start="2017-03-23" End="2017-03-25"/>
            <RatePlans>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="003"/>
            </RatePlans>
        </HotelAvailRequest>
        <HotelAvailRequest>
            <DateRange Start="2017-03-26" End="2017-03-26"/>
            <RatePlans>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
            </RatePlans>
        </HotelAvailRequest>
    </HotelAvailRequests>
</OTA_HotelAvailGetRQ>' "https://ari.staging.weekendesk.com/ari/"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('https://ari.staging.weekendesk.com/ari/');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'content-type' => 'text/xml',
  'authorization' => 'Basic TEStTesttEsTt3st'
));

$request->setBody('<OTA_HotelAvailGetRQ xmlns="http://www.opentravel.org/OTA/2003/05" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     Version="1.0" TimeStamp="2016-02-26T10:32:51" Target="Production">
    <HotelAvailRequests HotelCode="AL_TEST">
        <HotelAvailRequest>
            <DateRange Start="2017-03-23" End="2017-03-25"/>
            <RatePlans>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="003"/>
            </RatePlans>
        </HotelAvailRequest>
        <HotelAvailRequest>
            <DateRange Start="2017-03-26" End="2017-03-26"/>
            <RatePlans>
                <RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
            </RatePlans>
        </HotelAvailRequest>
    </HotelAvailRequests>
</OTA_HotelAvailGetRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("https://ari.staging.weekendesk.com/ari/");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("content-type", "text/xml");
request.AddHeader("authorization", "Basic TEStTesttEsTt3st");
request.AddParameter("text/xml", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<OTA_HotelAvailGetRQ xmlns=\"http://www.opentravel.org/OTA/2003/05\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n                     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n                     Version=\"1.0\" TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\n    <HotelAvailRequests HotelCode=\"AL_TEST\">\n        <HotelAvailRequest>\n            <DateRange Start=\"2017-03-23\" End=\"2017-03-25\"/>\n            <RatePlans>\n                <RatePlan InvTypeCode=\"RO_TEST\" RatePlanCode=\"001\"/>\n                <RatePlan InvTypeCode=\"RO_TEST\" RatePlanCode=\"003\"/>\n            </RatePlans>\n        </HotelAvailRequest>\n        <HotelAvailRequest>\n            <DateRange Start=\"2017-03-26\" End=\"2017-03-26\"/>\n            <RatePlans>\n                <RatePlan InvTypeCode=\"RO_TEST\" RatePlanCode=\"001\"/>\n            </RatePlans>\n        </HotelAvailRequest>\n    </HotelAvailRequests>\n</OTA_HotelAvailGetRQ>", ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<?xml version=\"1.0\"
encoding=\"UTF-8\"?>\n<OTA_HotelAvailGetRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\"
xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n                    
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n                    
Version=\"1.0\" TimeStamp=\"2016-02-26T10:32:51\" Target=\"Production\">\n   
<HotelAvailRequests HotelCode=\"AL_TEST\">\n       
<HotelAvailRequest>\n            <DateRange Start=\"2017-03-23\"
End=\"2017-03-25\"/>\n            <RatePlans>\n                <RatePlan
InvTypeCode=\"RO_TEST\" RatePlanCode=\"001\"/>\n                <RatePlan
InvTypeCode=\"RO_TEST\" RatePlanCode=\"003\"/>\n           
</RatePlans>\n        </HotelAvailRequest>\n       
<HotelAvailRequest>\n            <DateRange Start=\"2017-03-26\"
End=\"2017-03-26\"/>\n            <RatePlans>\n                <RatePlan
InvTypeCode=\"RO_TEST\" RatePlanCode=\"001\"/>\n           
</RatePlans>\n        </HotelAvailRequest>\n   
</HotelAvailRequests>\n</OTA_HotelAvailGetRQ>");
Request request = new Request.Builder()
  .url("https://ari.staging.weekendesk.com/ari/")
  .post(body)
  .addHeader("authorization", "Basic TEStTesttEsTt3st")
  .addHeader("content-type", "text/xml")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailGetRS
	xmlns="http://www.opentravel.org/OTA/2003/05"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1" TimeStamp="2016-02-26T10:32:51" Target="Production">
	<Success />
	<AvailStatusMessages HotelCode="AL_TEST">
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-23" End="2017-03-23" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-24" End="2017-03-24" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
	</AvailStatusMessages>
</OTA_HotelAvailGetRS>
```

```shell
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailGetRS
	xmlns="http://www.opentravel.org/OTA/2003/05"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1" TimeStamp="2016-02-26T10:32:51" Target="Production">
	<Success />
	<AvailStatusMessages HotelCode="AL_TEST">
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-23" End="2017-03-23" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-24" End="2017-03-24" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
	</AvailStatusMessages>
</OTA_HotelAvailGetRS>
```

```php
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailGetRS
	xmlns="http://www.opentravel.org/OTA/2003/05"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1" TimeStamp="2016-02-26T10:32:51" Target="Production">
	<Success />
	<AvailStatusMessages HotelCode="AL_14292">
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-23" End="2017-03-23" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-24" End="2017-03-24" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
	</AvailStatusMessages>
</OTA_HotelAvailGetRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailGetRS
	xmlns="http://www.opentravel.org/OTA/2003/05"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1" TimeStamp="2016-02-26T10:32:51" Target="Production">
	<Success />
	<AvailStatusMessages HotelCode="AL_TEST">
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-23" End="2017-03-23" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-24" End="2017-03-24" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
	</AvailStatusMessages>
</OTA_HotelAvailGetRS>
```

```java
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelAvailGetRS
	xmlns="http://www.opentravel.org/OTA/2003/05"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="1" TimeStamp="2016-02-26T10:32:51" Target="Production">
	<Success />
	<AvailStatusMessages HotelCode="AL_TEST">
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-23" End="2017-03-23" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
		<AvailStatusMessage BookingLimit="12">
			<StatusApplicationControl Start="2017-03-24" End="2017-03-24" InvTypeCode="RO_TEST" RatePlanCode="001" />
			<LenghtsOfStay>
				<LenghtOfStay MinLOS="2" MaxLOS="99" />
			</LenghtsOfStay>
			<RestrictionStatus Restriction="Master" Status="Close"/>
			<RestrictionStatus Restriction="Arrival" Status="Open"/>
			<RestrictionStatus Restriction="Departure" Status="Open"/>
		</AvailStatusMessage>
	</AvailStatusMessages>
</OTA_HotelAvailGetRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Version | string | Yes | 1.0 is the latest version
TimeStamp | date | Yes | TimeStamp of the request (YYY-MM-DD-THH:MM:SS)
Target | string | Yes | Testing=Test environment; Production=Prod environment
HotelCode | string | Yes | The Weekendesk Hotel ID
Start | date | Yes | Starting date of the updated period (YYY-MM-DD). The Start date is included in the updated period.
End | date | Yes | Ending date of the updated period (YYY-MM-DD). The End date is included in the updated period.
InvTypeCode | string | Yes | Code of the Room for which the update is sent
RatePlanCode | string | Yes | Code of the Rate Plan for which the update is sent

##Read RatePlans

The RatePlan request allows the ChannelManager partner to request rates for a specific Room and RatePlan.
<br>
<aside class="notice">
Remember, due to performance constraints <code>only one data range is allowed</code> within the same request.
</aside>

```xml
HEADER
Authorization: Basic TEStTesttEsTt3st
Content-Type: text/xml

BODY
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRatePlanRQ xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2016-02-26T10:32:51">
	<RateAmountMessages HotelCode="AL_TEST">
		<RateAmountMessage>
			<DateRange Start="2017-10-23" End="2017-10-25"/>
		<RatePlans>				
			<RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
      <RatePlan InvTypeCode="RO_TEST" RatePlanCode="002"/>
		</RatePlans>
		</RateAmountMessage>
	</RateAmountMessages>
</OTA_HotelRatePlanRQ>
```

```shell
curl
-X POST
-H "Authorization: Basic TEStTesttEsTt3st"
-H "Content-Type: text/xml"
-H "Cache-Control: no-cache"
-d '<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRatePlanRQ xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2016-02-26T10:32:51">
	<RateAmountMessages HotelCode="AL_TEST">
		<RateAmountMessage>
			<DateRange Start="2017-10-23" End="2017-10-25"/>
		<RatePlans>				
			<RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
		</RatePlans>
		</RateAmountMessage>
		<RateAmountMessage>
			<DateRange Start="2017-10-23" End="2017-10-25"/>
		<RatePlans>				
			<RatePlan InvTypeCode="RO_TEST" RatePlanCode="002"/>
		</RatePlans>
		</RateAmountMessage>
	</RateAmountMessages>
</OTA_HotelRatePlanRQ>' "http://test-standard-ari-gateway.weekendesk.com/ari"
```

```php
<?php

$request = new HttpRequest();
$request->setUrl('http://test-standard-ari-gateway.weekendesk.com/ari');
$request->setMethod(HTTP_METH_POST);

$request->setHeaders(array(
  'cache-control' => 'no-cache',
  'content-type' => 'text/xml',
  'authorization' => 'Basic MTAyOmlhdGVhc2hh'
));

$request->setBody('<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelRatePlanRQ xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2016-02-26T10:32:51">
	<RateAmountMessages HotelCode="AL_TEST">
		<RateAmountMessage>
			<DateRange Start="2017-10-23" End="2017-10-25"/>
		<RatePlans>				
			<RatePlan InvTypeCode="RO_TEST" RatePlanCode="001"/>
		</RatePlans>
		</RateAmountMessage>
		<RateAmountMessage>
			<DateRange Start="2017-10-23" End="2017-10-25"/>
		<RatePlans>				
			<RatePlan InvTypeCode="RO_TEST" RatePlanCode="002"/>
		</RatePlans>
		</RateAmountMessage>
	</RateAmountMessages>
</OTA_HotelRatePlanRQ>');

try {
  $response = $request->send();

  echo $response->getBody();
} catch (HttpException $ex) {
  echo $ex;
}
```

```csharp
var client = new RestClient("http://test-standard-ari-gateway.weekendesk.com/ari");
var request = new RestRequest(Method.POST);
request.AddHeader("cache-control", "no-cache");
request.AddHeader("content-type", "text/xml");
request.AddHeader("authorization", "Basic MTAyOmlhdGVhc2hh");
request.AddParameter("text/xml", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<OTA_HotelRatePlanRQ
xmlns=\"http://www.opentravel.org/OTA/2003/05\" TimeStamp=\"2016-02-26T10:32:51\">\n\t<RateAmountMessages HotelCode=\"AL_TEST\">\n\t\t<RateAmountMessage>\n\t\t\t<DateRange Start=\"2017-10-23\" End=\"2017-10-25\"/>\n\t\t<RatePlans>\t\t\t\t\n\t\t\t<RatePlan InvTypeCode=\"RO_TEST\" RatePlanCode=\"001\"/> \n\t\t</RatePlans> \n\t\t</RateAmountMessage>\n\t\t<RateAmountMessage>\n\t\t\t<DateRange Start=\"2017-10-23\" End=\"2017-10-25\"/>\n\t\t<RatePlans>\t\t\t\t\n\t\t\t<RatePlan InvTypeCode=\"RO_TEST\" RatePlanCode=\"002\"/> \n\t\t</RatePlans> \n\t\t</RateAmountMessage>\n\t</RateAmountMessages>\n</OTA_HotelRatePlanRQ>", ParameterType.RequestBody);
IRestResponse response = client.Execute(request);
```

```java
OkHttpClient client = new OkHttpClient();

MediaType mediaType = MediaType.parse("text/xml");
RequestBody body = RequestBody.create(mediaType, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<OTA_HotelRatePlanRQ xmlns=\"http://www.opentravel.org/OTA/2003/05\" TimeStamp=\"2016-02-26T10:32:51\">\n\t<RateAmountMessages HotelCode=\"AL_TEST\">\n\t\t<RateAmountMessage>\n\t\t\t<DateRange Start=\"2017-10-23\" End=\"2017-10-25\"/>\n\t\t<RatePlans>\t\t\t\t\n\t\t\t<RatePlan InvTypeCode=\"RO_TEST\" RatePlanCode=\"001\"/> \n\t\t</RatePlans> \n\t\t</RateAmountMessage>\n\t\t<RateAmountMessage>\n\t\t\t<DateRange Start=\"2017-10-23\" End=\"2017-10-25\"/>\n\t\t<RatePlans>\t\t\t\t\n\t\t\t<RatePlan InvTypeCode=\"RO_TEST\" RatePlanCode=\"002\"/> \n\t\t</RatePlans> \n\t\t</RateAmountMessage>\n\t</RateAmountMessages>\n</OTA_HotelRatePlanRQ>");
Request request = new Request.Builder()
  .url("http://test-standard-ari-gateway.weekendesk.com/ari")
  .post(body)
  .addHeader("authorization", "Basic MTAyOmlhdGVhc2hh")
  .addHeader("content-type", "text/xml")
  .addHeader("cache-control", "no-cache")
  .build();

Response response = client.newCall(request).execute();
```

> The above request returns XML structured like this:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_HotelRatePlanRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2017-11-24T08:59:08.992Z" Version="1.0">
    <Success/>
    <RatePlans HotelCode="AL_TEST">
        <RatePlan End="2017-12-23" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-23">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-24" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-24">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-25" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-25">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
    </RatePlans>
</OTA_HotelRatePlanRS>
```

```shell
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_HotelRatePlanRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2017-11-24T08:59:08.992Z" Version="1.0">
    <Success/>
    <RatePlans HotelCode="AL_TEST">
        <RatePlan End="2017-12-23" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-23">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-24" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-24">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-25" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-25">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
    </RatePlans>
</OTA_HotelRatePlanRS>
```

```php
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_HotelRatePlanRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2017-11-24T08:59:08.992Z" Version="1.0">
    <Success/>
    <RatePlans HotelCode="AL_TEST">
        <RatePlan End="2017-12-23" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-23">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-24" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-24">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-25" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-25">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
    </RatePlans>
</OTA_HotelRatePlanRS>
```

```csharp
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_HotelRatePlanRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2017-11-24T08:59:08.992Z" Version="1.0">
    <Success/>
    <RatePlans HotelCode="AL_TEST">
        <RatePlan End="2017-12-23" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-23">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-24" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-24">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-25" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-25">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
    </RatePlans>
</OTA_HotelRatePlanRS>
```

```java
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<OTA_HotelRatePlanRS xmlns="http://www.opentravel.org/OTA/2003/05" TimeStamp="2017-11-24T08:59:08.992Z" Version="1.0">
    <Success/>
    <RatePlans HotelCode="AL_TEST">
        <RatePlan End="2017-12-23" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-23">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-24" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-24">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
        <RatePlan End="2017-12-25" InvTypeCode="RO_TEST" RatePlanCode="003" Start="2017-12-25">
            <Rates>
                <Rate>
                    <BaseByGuestAmts>
                        <BaseByGuestAmt AgeQualifyingCode="10" AmountAfterTax="56.00" NumberOfGuests="2"/>
                    </BaseByGuestAmts>
                </Rate>
            </Rates>
        </RatePlan>
    </RatePlans>
</OTA_HotelRatePlanRS>
```

### HTTP Request

Testing:<br>
`POST` https://ari.staging.weekendesk.com/ari/
<br>Production:<br>
`POST` http://ari.weekendesk.com/ari/

### Query Parameters

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Version | string | Yes | 1.0 is the latest version
TimeStamp | date | Yes | TimeStamp of the request (YYY-MM-DD-THH:MM:SS)
Target | string | Yes | Testing=Test environment; Production=Prod environment
HotelCode | string | Yes | The Weekendesk Hotel ID
Start | date | Yes | Starting date of the updated period (YYY-MM-DD). The Start date is included in the updated period.
End | date | Yes | Ending date of the updated period (YYY-MM-DD). The End date is included in the updated period.
InvTypeCode | string | Yes | Code of the Room for which the update is sent
RatePlanCode | string | Yes | Code of the Rate Plan for which the update is sent

#Reservation Delivery

The Reservation delivery allows the ChannelManager partner to receive both Booking and Cancel Notifications real time via the web-service.<br>
Weekendesk Reservation API is based on XML messages based on the standards OTA (http://www.opentravel.org/)<br>
<br>
Specifically the following are used for notifying the ChannelManager partner of a Booking or Cancellation:<br>
<br>
- OTA_HotelResRQ/RS<br>
- OTA_CancelRQ/RS<br>
<br>

## Booking Notification

Booking notifications allows the ChannelManager partner to be acknowledged about a new booking that entered into the Weekendesk system.<br>
Once received the notification, and successfully confirmed, it is responsability of the ChannelManager partner to notify the hotel in order to reserve the room(s) for the stay.

### HTTP Request

Endpoint:<br>
`POST` https://channel-manager-endpoint.com

<aside class="success">
Remember - Before starting receiving Booking Notifications <b>send the Endpoint and Credentials (if any)</b> of both your testing and production environment to your technical contact at Weekendesk.
</aside>

### Booking Request

### Authentication

```xml
<POS>
    <Source>
      <RequestorID ID="user" MessagePassword="password"/>
    </Source>
</POS>

```

Element | Type |  Description
--------- | ------- | -----------
@RequestorID |  |  
ID | string | User provided by the ChannelManager partner to authenticate the request
MessagePassword | string | Password provided by the ChannelManager partner to authenticate the request

### Room Information

```xml
<RoomStays>
   <RoomStay>
       <RoomTypes>
           <RoomType RoomTypeCode="RO_TEST" RoomType="Classic Room"
                     NumberOfUnits="1"/>
       </RoomTypes>
       <RatePlans>
          <RatePlan RatePlanCode="004" RatePlanName="004">
              <Rate EffectiveDate="2017-10-31" ExpireDate="2017-11-01">
                 <Base AmountAfterTax="116.00" CurrencyCode="EUR">
                 </Base>
              </Rate>
           </RatePlan>
         </RatePlans>
       <GuestCounts>
            <GuestCount AgeQualifyingCode="10" Count="2" ResGuestRPH="1"/>
            <GuestCount AgeQualifyingCode="8" Count="1" ResGuestRPH="2"/>
       </GuestCounts>
       <TimeSpan Start="2017-10-31" End="2017-11-01"/>
       <BasicPropertyInfo BrandCode="BC_TEST" HotelCode="AL_TEST" HotelName="Hotel Test"/>
   </RoomStay>
</RoomStays>
```

Element | Type | Description
--------- | ------- | -----------
@RoomType |  |  |
RoomTypeCode | string | RoomCode of the Room that is being reserved
RoomType | string | Room Name of the Room that is being reserved
NumberOfUnits | integer | Number of Rooms that are being reserved
@RatePlan |  |  |
RatePlanCode | string | RatePlanCode of the RatePlan that is being reserved
RatePlanName | string | RatePlan Name of the RatePlan that is being reserved
@Rate |  |  
EffectiveDate | date | StartDate of a night stay for each day that is being reserved (YYY-MM-DD)
ExpireDate | date | EndDate of a night stay for each day that is being reserved (YYY-MM-DD)
@Base |  |  
AmountAfterTax | decimal | Day price for which a Room is being reserved at a specific Rate.
CurrencyCode | string | Currency used to specify the Day price.
@GuestCount |  |  
AgeQualifyingCode | integer | AgeCategory of the Guests for which the Room is being reserved. 10=Adults, 8=Children, 7=Babies
Count | integer | Total number of guests for a specific AgeCategory
ResGuestRPH | integer | Incremental number of GuestCount (which defines the types of AgeCategory included in this reservation)
@TimeSpan |  |  
Start | date | Date of the CheckIn
End | date | Date of the CheckOut
@BasicPropertyInfo |  |
BrandCode | string | Weekendesk Chain code of the hotel
HotelCode | string | Weekendesk Hotel code of the hotel
HotelName | string | Name of the hotel

### Services information

```xml
<Services>
    <Service Quantity="1" ServicePricingType="Per stay" >
        <Price>
            <Base AmountAfterTax="0.00" CurrencyCode="EUR" />
        </Price>
        <ServiceDetails>
          <TimeSpan Duration="P1D" />
        </ServiceDetails>
        <TPA_Extensions>
          <Description Language="ES">
            <Text>Supplement accomodation children</Text>
          </Description>
        </TPA_Extensions>
    </Service>
</Services>
```

Element | Type | Description
--------- | ------- | -----------
@Service |  |  
Quantity | integer | Quantity of the service offered by the hotel within the reservation (2 dinners, 1 massage)
ServicePricingType | string | Pricing model offered for the service (Per person, per night, per room)
@Base |  |  
AmountAfterTax | decimal | Price paid for a specific service and already included in the total price
AmountAfterTax | string | Currency in which the price is expressed
@TimeSpan |  |  |
Duration | string | The service duration<br>P1D means:<br>Period 1 day (1night)<br> P2D means:<br>Period 2 days (2 nights)
@Description |  |  
Language | string | Language in which the service is described
Text | string | Description of the service

### Guest Information

```xml
<ResGuest ResGuestRPH="1" AgeQualifyingCode="10">
    <Profiles>
        <ProfileInfo>
            <Profile ProfileType="1">
                <Customer>
                    <PersonName>
                        <NamePrefix>Mr</NamePrefix>
                        <GivenName><![CDATA[Test]]></GivenName>
                        <Surname><![CDATA[Test]]></Surname>
                    </PersonName>
                    <Telephone PhoneNumber="1234567" PhoneLocationType="1" PhoneTechType="1"/>
                    <Email>test@weekendesk.com</Email>
                    <Address>
                        <AddressLine><![CDATA[ _]]></AddressLine>
                        <CityName><![CDATA[Barcelona]]></CityName>
                        <PostalCode><![CDATA[8024]]></PostalCode>
                        <CountryName><![CDATA[Italie]]></CountryName>
                    </Address>
                </Customer>
            </Profile>
        </ProfileInfo>
    </Profiles>
</ResGuest>
```

Element | Type | Description
--------- | ------- |-----------
@ResGuest |  |  
ResGuestRPH | integer | Always set as 1 to identify the customer
AgeQualifyingCode | integer | Always set as 10 which defines the AgeCategory of the  customer (adult)
@Profile |  |  
ProfileType | integer | Always set as 1 which defines the customer
@PersonName |  |  
NamePrefix | string | Civility of the customer
GivenName | CDATA | First name of the customer
Surname | CDATA |  Last name of the customer
@Telephone |  |  
PhoneNumber | string | Phone number of the customer
PhoneLocationType | string | Fixed value set as 1
PhoneTechType | string | Fixed value set as 1
Email | string | Email of the customer
AddressLine | CDATA | Always blank - not needed
CityName | CDATA | City of the customer
PostalCode | CDATA | Postal code of the customer
CountryName | CDATA | Country of the customer

### Global Information

```xml
<ResGlobalInfo>
    <TimeSpan Start="2017-07-12" End="2017-07-14" Duration="P2D"/>
    <Comments>
        <Comment>
            <Text><![CDATA[2 nuits en chambre double standard vue lac pour 4 adultes. Entrée au Zoo pour 4 adultes]]></Text>
        </Comment>
    </Comments>
    <Total AmountAfterTax="840.00" CurrencyCode="EUR"/>
    <HotelReservationIDs>
        <HotelReservationID ResID_Type="5" ResID_Value="123456" ResID_Source="Weekendesk" ResID_Date="2017-06-08T09:38:30.655"/>
        <HotelReservationID ResID_Type="14" ResID_Value="ABC123" ResID_Source="ChannelManagerPartner" ResID_Date="2017-06-08T09:38:30.655"/>
    </HotelReservationIDs>
    <Guarantee>
         <GuaranteesAccepted>
             <GuaranteeAccepted>
                 <PaymentCard CardNumber="1111222233334444" ExpireDate="1219"
                              SeriesCode="123" CardType="MC"
                              CardCode="VCC" CardHolderName="WEEKENDESK"
                              VCCAmount="232.75 EUR"/>
             </GuaranteeAccepted>
         </GuaranteesAccepted>
     </Guarantee>
</ResGlobalInfo>
```

Element | Type | Description
--------- | ------- |-----------
@TimeSpan |  |  
Start | date | CheckIn date
End | date | CheckOut date
Duration | string | The booking duration:<br>P1D means:<br>Period 1 day (1night)<br>P2D means:<br>Period 2 days (2 nights)<br>P3D…Etc.
@Comment |  |  
Text | CDATA | Description of the package booked
@Total |  |  
AmountAfterTax | decimal | Total price of the stay booked (including services and activities)
CurrencyCode | string | Currency of the amount. Always "EUR"
@HotelReservationID |  |  
ResID_Type | integer | 5=Weekendesk Reservation number; 14=ChannelManager partner reservation number
ResID_Value | string | Reservation number
ResID_Source | string | Weekendesk or ChannelManager partner
ResID_Date | date | TimeStamp of integration of the reservation
@PaymentCard |  |
CardNumber | integer | Number of the Virtual Credit Card that should be used by the hotel
ExpireDate | integer | Expiration date of the card
SeriesCode | integer | CVV – Security number
CardType | string | Type of the credit card (MC=Mastercard)
CardCode | string | Type of card - always VCC (Virtual Credit Card)
CardHolderName | string | Card Holder Name
VCCAmount | string | Amount that should be charged to the card.


### Booking Response

> The above request sent to the ChannelManager partner should be the following XML:

```xml
<OTA_HotelResRS xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="1.0"
  ResResponseType="Committed"
  xmlns="http://www.opentravel.org/OTA/2003/05"><Success/>
  <HotelReservations>
      <HotelReservation>
        <ResGlobalInfo>
          <HotelReservationIDs>
            <HotelReservationID ResID_Type="5" ResID_Value="12345678"
              ResID_Source="Weekendesk"
              ResID_Date="2017-09-27T18:32:43.612"/>
            <HotelReservationID ResID_Type="14" ResID_Value="ABCDEFG"
              ResID_Source="ChannelManager"
              ResID_Date="2017-09-28T02:32:44.9882167+10:00"/>
            </HotelReservationIDs>
        </ResGlobalInfo>
    </HotelReservation>
  </HotelReservations>
</OTA_HotelResRS>
```

Element | Type | Required | Description
--------- | ------- | ----- |-----------
ResResponseType | string | Yes | Always "Committed" if correctly saved into the Channel system
ResID_Type | integer | Yes | 5=Weekendesk Reservation number; 14=ChannelManager partner reservation number
ResID_Value | string | Yes | Reservation number
ResID_Source | string | Yes | Weekendesk or ChannelManager partner
ResID_Date | date | Yes | TimeStamp of integration of the reservation

<aside class="success">
Remember — Both ResID_Type=5 and ResID_Type=14 must be returned. In case the ChannelManager partner is not generating a new booking number can send back for the Type 14 any value.
</aside>


### Example of Booking Request

Here an example of a request and the response expected from the ChannelManager partner with all the elements included in the body.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_HotelResRQ xmlns="http://www.opentravel.org/OTA/2003/05"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.opentravel.org/OTA/2003/05 OTA_HotelResRQ.xsd"
Version="1.0"
                ResStatus="Commit" PrimaryLangID="en-US">
    <POS>
        <Source>
        <RequestorID ID="user" MessagePassword="password"/>
        </Source>
    </POS>
    <HotelReservations>
        <HotelReservation>
            <RoomStays>
                <RoomStay>
                    <RoomTypes>
                        <RoomType RoomTypeCode="RO_TEST"
                        RoomType="Classic Room"
                                  NumberOfUnits="1"/>
                    </RoomTypes>
                    <RatePlans>
                                                    <RatePlan RatePlanCode="004"
                                                    RatePlanName="004">
                                <Rate EffectiveDate="2017-10-31"
                                      ExpireDate="2017-11-01">
                                    <Base AmountAfterTax="116.00"
                                    CurrencyCode="EUR"></Base>
                                </Rate>
                            </RatePlan>
                                            </RatePlans>
                    <GuestCounts>
                            <GuestCount AgeQualifyingCode="10" Count="2"
                            ResGuestRPH="1"/>
                            <GuestCount AgeQualifyingCode="8" Count="1"
                            ResGuestRPH="2"/>
                    </GuestCounts>
                    <TimeSpan Start="2017-10-31"
                              End="2017-11-01"/>
                    <BasicPropertyInfo BrandCode="BC_TEST" HotelCode="AL_TEST"
                                       HotelName="Hotel Test"/>
                </RoomStay>
            </RoomStays>
            <Services>
                <Service Quantity="1" ServicePricingType="Per stay" >
                    <Price>
                        <Base AmountAfterTax="0.00" CurrencyCode="EUR" />
                    </Price>
                    <ServiceDetails>
                        <TimeSpan Duration="P1D" />
                    </ServiceDetails>
                    <TPA_Extensions>
                        <Description Language="ES">
                            <Text>Supplement accomodation children</Text>
                        </Description>
                    </TPA_Extensions>
                </Service>
            </Services>
            <ResGuests>
                <ResGuest ResGuestRPH="1" AgeQualifyingCode="10">
                    <Profiles>
                        <ProfileInfo>
                            <Profile ProfileType="1">
                                <Customer>
                                    <PersonName>
                                        <NamePrefix>Ms</NamePrefix>
                                        <GivenName><![CDATA[Test]]></GivenName>
                                        <Surname><![CDATA[Test]]></Surname>
                                    </PersonName>
                                    <Telephone PhoneNumber="123456789" PhoneLocationType="1" PhoneTechType="1"/>
                                    <Email>test@test.com</Email>
                                    <Address>
                                        <AddressLine><![CDATA[Test]]></AddressLine>
                                        <CityName><![CDATA[Test]]></CityName>
                                        <PostalCode><![CDATA[128398]]></PostalCode>
                                        <CountryName><![CDATA[Test]]></CountryName>
                                    </Address>
                                </Customer>
                            </Profile>
                        </ProfileInfo>
                    </Profiles>
                </ResGuest>
            </ResGuests>
            <ResGlobalInfo>
                <TimeSpan Start="2017-10-31"
                          End="2017-11-01"
                          Duration="P1D"/>
                <Comments>
                    <Comment>
                        <Text><![CDATA[
                            1 noche junior suite superior para 2 adultos y 1 niño. 1 desayuno continental (buffet) para 2 adultos y 1 niño
                            Buenas tardes,  tal y como hablamos por tel&eacute;fono,  os indico que venimos con un beb&eacute; de 2 meses por lo que necesitamos la cuna tambi&eacute;n (a parte de la cama supletoria). Muchas gracias
                            Number of children:1.Extra costs for staying and/or meals of the children must be paid for directly to the hotel.
                            ]]></Text>
                    </Comment>
                    <Comment>
                            <Text><![CDATA[Weekendesk pagará esta reserva al hotel mediante tarjeta de crédito virtual. Importe total: 92.80 EUR EUR. La cantidad estará disponible para ser retirada desde el 01/11/2017 hasta el 01/12/2017.]]></Text>
                    </Comment>
                </Comments>
                <Total AmountAfterTax="116.00" CurrencyCode="EUR"/>
                <HotelReservationIDs>
                    <HotelReservationID ResID_Type="5" ResID_Value="12345678" ResID_Source="Weekendesk"
                                        ResID_Date="2017-09-19T17:50:41.059"/>
                                            <HotelReservationID ResID_Type="14" ResID_Value="ABCDEFGH"
                                            ResID_Source="ChannelManager"
                                            ResID_Date="2017-09-19T17:50:41.059"/>
                </HotelReservationIDs>
            <Guarantee>
                <GuaranteesAccepted>
                    <GuaranteeAccepted>
                      <PaymentCard CardNumber="1111222233334444" ExpireDate="1219"
                             SeriesCode="123" CardType="MC"
                             CardCode="VCC" CardHolderName="WEEKENDESK"
                             VCCAmount="232.75 EUR"/>
                    </GuaranteeAccepted>
                </GuaranteesAccepted>
            </Guarantee>
          </ResGlobalInfo>
        </HotelReservation>
    </HotelReservations>
</OTA_HotelResRQ>
```


## Cancel Notification

Cancellation notifications allows the ChannelManager partner to be acknowledged about a new cancellation that has been made into the Weekendesk system.<br>
Once received the notification, and successfully confirmed, it is responsability of the ChannelManager partner to notify the hotel in order to cancel the reservation of a previously confirmed stay.

### HTTP Request

Endpoint:<br>
`POST` https://channel-manager-endpoint.com

<aside class="success">
Remember - Before starting receiving Cancellation Notifications <b>send the Endpoint and Credentials (if any)</b> of both your testing and production environment to your technical contact at Weekendesk.
</aside>

### Cancellation Request

```xml
<?xml version="1.0" encoding="UTF-8"?>
<OTA_CancelRQ Version="1.0" CancelType="Commit" xmlns="http://www.opentravel.org/OTA/2003/05">
    <POS>
        <Source>
        <RequestorID ID="user" MessagePassword="password" HotelID="AL_TEST"/>
        </Source>
    </POS>
    <HotelReservationIDs>
        <HotelReservationID ResID_Type="5"
                            ResID_Value="12345678"
                            ResID_Source="Weekendesk"
                            ResID_Date="2017-09-26T17:29:03.743"/>
        <HotelReservationID ResID_Type="14"
                            ResID_Value="ABC123CDE"
                            ResID_Source="ChannelManager"
                            ResID_Date="2017-09-26T17:29:03.743"/>
    </HotelReservationIDs>
    </OTA_CancelRQ>
```

Element | Type |  Description
--------- | ------- | -----------
CancelType | string | Weekendesk always send Commit
@RequestorID |  |
ID | string | User provided by the ChannelManager partner to authenticate the request
MessagePassword | string | Password provided by the ChannelManager partner to authenticate the request
HotelID | string | Hotel ID for which the cancellation is requested
@HotelReservationID |  |
ResID_Type | integer | 5=Weekendesk Reservation number; 14=ChannelManager partner reservation number
ResID_Value | string | Reservation number
ResID_Source | string | Weekendesk or ChannelManager partner
ResID_Date | date | TimeStamp of integration of the cancellation

### Cancel Response

> The above request sent to the ChannelManager partner should be the following XML:

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<OTA_CancelRS xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="1.00"  Status="Cancelled" xmlns="http://www.opentravel.org/OTA/2003/05">
    <Success />
        <HotelReservations>
            <HotelReservation>
                <ResGlobalInfo>
                    <HotelReservationIDs>
                          <HotelReservationID ResID_Type="5" ResID_Value="12345678"	ResID_Source="Weekendesk" ResID_Date="2017-10-01T12:23:26+2"/>
                          <HotelReservationID ResID_Type="14" ResID_Value="987654321" ResID_Source="ChannelManager"  ResID_Date="2017-10-01T12:23:31" />
                    </HotelReservationIDs>
                </ResGlobalInfo>
            </HotelReservation>
        </HotelReservations>
</OTA_CancelRS>
```

Element | Type | Required | Description
--------- | ------- | ----- |-----------
Status | string | Yes | Send "Cancelled" to acknowledge Weekendesk that the reservation has been successfully cancelled
ResID_Type | integer | Yes | 5=Weekendesk Reservation number; 14=ChannelManager partner reservation number
ResID_Value | string | Yes | Reservation number
ResID_Source | string | Yes | Weekendesk or ChannelManager partner
ResID_Date | date | Yes | TimeStamp of the cancellation (YYYY-MM-DDThh:mm:ss)
