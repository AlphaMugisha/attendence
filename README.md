# Smart Attendance V8 — Final Integrated Build

Developed by **HAKIZIMANA Tumusifu David** for New Generation Academy.

## 1. IMPORTANT: deploy from the project root

This version fixes the common Firebase Hosting problem where the deployed site shows:

`Welcome — Firebase Hosting Setup Complete`

The Firebase configuration is now at the **project root**, and Hosting is explicitly configured to publish the `dashboard/` folder.

Your folder must look like this:

```text
Smart_Attendance_V8_FINAL/
├── firebase.json          <-- USE THIS ONE
├── .firebaserc
├── DEPLOY_WINDOWS.bat
├── dashboard/
│   ├── index.html
│   ├── app.js
│   └── style.css
├── firmware/
│   └── Smart_Attendance_V8_Integrated_Offline_Core.ino
├── firebase/
│   └── database.rules.json
├── COMPATIBILITY_CHECK.md
└── README.md
```

### Do NOT run `firebase init hosting` again

A new `firebase init hosting` can create a Firebase welcome page in a different public folder. Use the included `firebase.json` instead.

### Windows deployment

Open Command Prompt and run:

```bat
cd /d "C:\Users\user\Downloads\Smart_Attendance_V8_FINAL"
firebase login
firebase use --add
```

Select:

```text
rfid-attendance-system-a2579
```

Then deploy:

```bat
firebase deploy --only hosting
firebase deploy --only database
```

Or simply double-click:

```text
DEPLOY_WINDOWS.bat
```

### Verify the correct files before deploying

From the project root run:

```bat
dir dashboard
```

You must see:

```text
index.html
app.js
style.css
```

Then run:

```bat
firebase deploy --only hosting
```

The Hosting system will publish `dashboard/index.html`, not a generated Firebase welcome page.

## 2. If you still see the Firebase welcome page

You almost certainly deployed a different Firebase project directory.

Run:

```bat
cd /d "C:\Users\user\Downloads\Smart_Attendance_V8_FINAL"
firebase use
firebase projects:list
```

Confirm that the active project is:

```text
rfid-attendance-system-a2579
```

Then run:

```bat
firebase deploy --only hosting --project rfid-attendance-system-a2579
```

After deployment, hard-refresh the browser with:

```text
Ctrl + F5
```

Also check the deployed site in a private/incognito window.

## 3. Dashboard

The dashboard contains:

- Home / live attendance
- Students
- Teachers
- Registration
- History
- Reports and CSV downloads
- Notifications
- Settings
- Security / user roles
- Device heartbeat
- Sick / excused attendance controls
- Student and teacher attendance status
- Responsive desktop/mobile layout
- Dark mode

`style.css` is included and loaded by `dashboard/index.html`.

## 4. Firebase data structure

```text
students/{UID}
teachers/{UID}
studentStatus/{UID}
teacherStatus/{UID}
attendance/{DATE}/{EVENT_ID}
notificationQueue/{QUEUE_ID}
settings/
device/heartbeat
users/{AUTH_UID}
```

Unknown RFID UIDs are not stored in Firebase.

## 5. Firebase security

The included Realtime Database rules are role-aware.

Dashboard roles:

```text
admin
staff
teacher
viewer
```

The ESP8266 uses a dedicated Firebase device account. Do not use the administrator account on the ESP8266.

Create a matching device record at:

```text
users/{DEVICE_AUTH_UID}
```

with:

```text
role: "device"
active: true
```

IMPORTANT: the current security rules file must also explicitly allow the `device` role. Before production deployment, deploy the supplied rules and use the Firebase Rules Simulator to test the device reads/writes. Do not weaken the root rules to `.read: true` / `.write: true`.

## 6. Default timing

- Morning open: 05:00
- School start: 08:00
- Home time: 16:00
- Evening close: 19:00
- Duplicate scan interval: 60 seconds

These are dashboard-configurable.

## 7. Attendance behavior

Student:

```text
NOT_ARRIVED + before/at start -> ARRIVAL
NOT_ARRIVED + after start -> LATE_ARRIVAL
AT_SCHOOL/LATE/RETURNED + before home -> TEMPORARY_EXIT
LEFT_TEMP + before home -> RETURN
AT_SCHOOL/LATE/RETURNED + home time or later -> FINAL_EXIT
LEFT_FINAL -> blocked for the rest of the day
```

Teacher fixed schedule follows the configured start/home times. Flexible/hourly teachers use arrival/final behavior.

## 8. Offline and speed behavior

The ESP8266:

1. Loads its saved cache from LittleFS.
2. Uses the local person cache first when a card is tapped.
3. Decides attendance locally.
4. Saves local status/cache first.
5. Queues cloud writes when Firebase is unavailable.
6. Uploads queued data when Firebase returns.
7. Never waits for EmailJS before accepting the next card.

## 9. EmailJS

EmailJS is handled by the dashboard notification worker. Attendance processing on the ESP is independent from email delivery.

Failed notifications remain available for retry.

## 10. ESP8266 hardware

Board:

```text
NodeMCU 1.0 (ESP-12E)
```

Pins:

```text
RC522 SS   D8
RC522 RST  D4
LCD SDA    D2
LCD SCL    D1
GREEN LED  D3
RED LED    D0
SPI SCK    D5
SPI MISO   D6
SPI MOSI   D7
```

Libraries:

- ESP8266 Arduino core
- MFRC522
- LiquidCrystal_I2C
- LittleFS

## 11. Security warning

Do not publish firmware containing private Wi-Fi or Firebase device credentials. Keep those values private and move them to a local-only configuration before placing the firmware in a public repository.
