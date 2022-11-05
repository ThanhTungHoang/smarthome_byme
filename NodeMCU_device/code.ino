#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <EEPROM.h>
#if defined(ESP32)
#include <WiFi.h>
#include <FirebaseESP32.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
#endif
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>
String AP_SSID = "Switch_";
String AP_PASS = "";
String esid;
String epass;
String pathEmailUser;
// UDP
WiFiUDP UDP;
IPAddress local_IP(192, 168, 4, 1);
IPAddress gateway(192, 168, 4, 1);
IPAddress subnet(255, 255, 255, 0);
#define UDP_PORT 4210
String value, ssid , pass, user;
unsigned long previousMillis = 0;
unsigned long interval = 30000;
char packetBuffer[UDP_TX_PACKET_MAX_SIZE];
char  ReplyFail[] = "F";
char  ReplySucces[] = "S";
// Firebase
#define API_KEY "AIzaSyAKkkStOfYWz0YEPyifFWzQJhIO9oBsI-k"
#define DATABASE_URL "home-control-flutter-default-rtdb.firebaseio.com/"
#define USER_EMAIL "device@gmail.com"
#define USER_PASSWORD "device"
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
bool activeFirebase = false;
String pathIdDevice = "";
String pathNameDevice = "";
String pathTypeDevice = "";
String pathToggle = "";
String pathPing = "";
//
String branch = "admin";
String idESP = "Switch_";
String emailUser = "emailtest@gmail_com";
String nameDevice = "New Switch";
String typeDevice = "Switch";
//btn
byte ledStatus = LOW;
byte ping = 1;

void setup() {
  pinMode(15, OUTPUT); // D8
  pinMode(14, INPUT_PULLUP); //D5
  pinMode(2, OUTPUT);
  EEPROM.begin(512);
  Serial.begin(115200);
  AP_SSID += ESP.getChipId();
  idESP += ESP.getChipId();
  if (digitalRead(14) == LOW) {
    for (int i = 0; i < 96; ++i) {
      EEPROM.write(i, 0);
    }
    EEPROM.commit();
    ESP.reset();
  }
  int value = char(EEPROM.read(0));
  Serial.print("flag: ");
  Serial.println(value);
  if (value == 255 or value == 0 ) {
    Serial.println("Starting access point...");
    WiFi.softAPConfig(local_IP, gateway, subnet);
    WiFi.softAP(AP_SSID, AP_PASS);
    Serial.println(WiFi.localIP());
    UDP.begin(UDP_PORT);
    Serial.print("Listening on UDP port ");
    Serial.println(UDP_PORT);
    activeFirebase = false;
  }
  if (value > 0 and value < 255) {

    for (int i = 0; i < 32; ++i)
    {
      esid += char(EEPROM.read(i));
    }
    Serial.println();
    Serial.print("SSID: ");
    Serial.println(esid);
    for (int i = 32; i < 64; ++i)
    {
      epass += char(EEPROM.read(i));
    }
    Serial.print("PASS: ");
    Serial.println(epass);
    for (int i = 64; i < 96; ++i)
    {
      pathEmailUser += char(EEPROM.read(i));
    }
    Serial.print("pathEmailUser: ");
    Serial.println(pathEmailUser);
    WiFi.begin(esid, epass);
    delay(5000);
    Serial.print("Connecting to WiFi ..");
    Serial.println(WiFi.localIP());
    WiFi.setAutoReconnect(true);
    WiFi.persistent(true);
    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
    config.api_key = API_KEY;
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;
    config.database_url = DATABASE_URL;
    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
    Firebase.setDoubleDigits(5);
    String pathEmailUser_copy = String(pathEmailUser).c_str();
    pathIdDevice = "/" + branch + "/" + pathEmailUser_copy + "/Device/" + idESP + "/idDevice";
    pathNameDevice = "/" + branch + "/" + pathEmailUser_copy + "/Device/" + idESP + "/nameDevice";
    pathTypeDevice = "/" + branch + "/" + pathEmailUser_copy + "/Device/" + idESP + "/typeDevice";
    pathToggle = "/" + branch + "/" + pathEmailUser_copy + "/Device/" + idESP + "/toggle";
    pathPing = "/" + branch + "/" + pathEmailUser_copy + "/Device/" + idESP + "/ping";
    Serial.println(pathIdDevice);
    Serial.println(pathNameDevice);
    Serial.println(pathTypeDevice);
    Serial.println(pathToggle);
    Serial.println(pathPing);
    activeFirebase = true;

  }
  //


}

void loop() {
  Serial.print("ledStatus: ");
  Serial.println(ledStatus);
  ping = random(0, 10);
  if (activeFirebase == true) {
    digitalWrite(2, LOW);
    if (Firebase.getString(fbdo, pathIdDevice)) {
      Serial.println("device ready!");
      bool bVal ;
      if (Firebase.getBool(fbdo, pathToggle, &bVal)) {
        ledStatus = bVal;
        Firebase.setInt(fbdo, pathPing, ping);
        digitalWrite(2, HIGH);
      }
    }
  }

  if (ledStatus == 0) {
    digitalWrite(15, LOW);
  } else {
    digitalWrite(15, HIGH);
  }
  if (digitalRead(14) == LOW) {
    ESP.wdtDisable();
    while (digitalRead(14) == LOW);
    ledStatus = !ledStatus;
    if (activeFirebase == true) {
      Firebase.setBoolAsync(fbdo, pathToggle, ledStatus);
    }
    ESP.wdtEnable(1000);
  }

  delay(1000);
  unsigned long currentMillis = millis();
  if ((WiFi.status() != WL_CONNECTED) && (currentMillis - previousMillis >= interval)) {
    Serial.print(millis());
    Serial.println("Reconnecting to WiFi...");
    WiFi.disconnect();
    WiFi.begin(esid, epass);
    Serial.println(WiFi.localIP());
    //ESP.restart();
    Serial.println(WiFi.RSSI());
    previousMillis = currentMillis;
  }
  if (activeFirebase == false) {
    digitalWrite(2, HIGH);
    Serial.println("wait set up!");

    int packetSize = UDP.parsePacket();

    if (packetSize) {
      Serial.print("Received packet! Size: ");
      Serial.println(packetSize);
      int n = UDP.read(packetBuffer, 255);
      ssid;
      pass;
      user;
      if (n > 0)
      {
        packetBuffer[n] = 0;
        value = String(packetBuffer);
        Serial.print("value recive:");
        Serial.println(value);
      }
      //      WiFi.mode(WIFI_STA);
      ssid = getValue(value, '-', 0);
      pass = getValue(value, '-', 1);
      user = getValue(value, '-', 2);
      Serial.println(ssid);
      Serial.println(pass);
      Serial.println(user);
      WiFi.begin(ssid, pass);
      Serial.print("Connecting to WiFi ..");
      delay(5000);
      Serial.println(WiFi.status());
      if (WiFi.status() != WL_CONNECTED) {
        Serial.println("fail");
        UDP.beginPacket(UDP.remoteIP(), UDP.remotePort());
        UDP.write(ReplyFail);
        UDP.endPacket();
        WiFi.disconnect();
      } else {
        Serial.println("ok");
        String qsid = ssid;
        String qpass = pass;
        String quser = user;
        EEPROM.write(512, 1);
        if (qsid.length() > 0 && qpass.length() > 0 && qpass.length() > 0) {
          Serial.println("clearing eeprom");
          for (int i = 0; i < 96; ++i) {
            EEPROM.write(i, 0);
          }
          Serial.println(qsid);
          Serial.println("");
          Serial.println(qpass);
          Serial.println("");
          Serial.println(quser);
          Serial.println("");

          Serial.println("writing eeprom ssid:");
          for (int i = 0; i < qsid.length(); ++i)
          {
            EEPROM.write(i, qsid[i]);
            Serial.print("Wrote: ");
            Serial.println(qsid[i]);
          }
          Serial.println("writing eeprom pass:");
          for (int i = 0; i < qpass.length(); ++i)
          {
            EEPROM.write(32 + i, qpass[i]);
            Serial.print("Wrote: ");
            Serial.println(qpass[i]);
          }
          Serial.println("writing eeprom user:");
          for (int i = 0; i < quser.length(); ++i)
          {
            EEPROM.write(64 + i, quser[i]);
            Serial.print("Wrote: ");
            Serial.println(quser[i]);
          }
          EEPROM.commit();
          UDP.beginPacket(UDP.remoteIP(), UDP.remotePort());
          UDP.write(ReplySucces);
          UDP.endPacket();
          delay(100);

          pathIdDevice = "/" + branch + "/" + quser + "/Device/" + idESP + "/idDevice";
          pathNameDevice = "/" + branch + "/" + quser + "/Device/" + idESP + "/nameDevice";
          pathTypeDevice = "/" + branch + "/" + quser + "/Device/" + idESP + "/typeDevice";
          pathToggle = "/" + branch + "/" + quser + "/Device/" + idESP + "/toggle";
          pathPing = "/" + branch + "/" + quser + "/Device/" + idESP + "/ping";
          Serial.println(pathIdDevice);
          Serial.println(pathNameDevice);
          Serial.println(pathTypeDevice);
          Serial.println(pathToggle);
          Serial.println(pathPing);
          // create
          Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
          config.api_key = API_KEY;
          auth.user.email = USER_EMAIL;
          auth.user.password = USER_PASSWORD;
          config.database_url = DATABASE_URL;
          config.token_status_callback = tokenStatusCallback;
          Firebase.begin(&config, &auth);
          Firebase.reconnectWiFi(true);
          Firebase.setDoubleDigits(5);
          Firebase.setString(fbdo, pathIdDevice, idESP);
          Firebase.setString(fbdo, pathNameDevice, nameDevice);
          Firebase.setString(fbdo, pathTypeDevice, typeDevice);
          Firebase.setInt(fbdo, pathPing, 10);
          Firebase.setBool(fbdo, pathToggle, false);
          ESP.reset();
        }
      }
    }

  }

}
String getValue(String data, char separator, int index)
{
  int found = 0;
  int strIndex[] = { 0, -1 };
  int maxIndex = data.length() - 1;

  for (int i = 0; i <= maxIndex && found <= index; i++) {
    if (data.charAt(i) == separator || i == maxIndex) {
      found++;
      strIndex[0] = strIndex[1] + 1;
      strIndex[1] = (i == maxIndex) ? i + 1 : i;
    }
  }
  return found > index ? data.substring(strIndex[0], strIndex[1]) : "";
}