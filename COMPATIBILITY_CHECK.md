# Smart Attendance V8 — Compatibility Check

## Source basis
The V8 firmware was based on the saved `Smart_Attendance_V8_Speed_Cache_Test_20_FIXED.ino` and preserves the requested NodeMCU 1.0 pin map.

## Shared Firebase paths
- `students/{uid}` — student registration cache source
- `teachers/{uid}` — teacher registration cache source
- `studentStatus/{uid}` — current student state
- `teacherStatus/{uid}` — current teacher state
- `attendance/{date}/{eventId}` — history
- `notificationQueue/{eventId}` — EmailJS queue
- `settings/*` — timing and notification settings
- `device/heartbeat` — machine health
- `users/{authUid}` — dashboard role
- `devices/{authUid}` — machine account authorization

## Unknown-card policy
Unknown UIDs are displayed locally/serially for registration assistance only. The firmware does not create an `unknownCards` or `unknown_uids` Firebase record.

## Cache behavior
The ESP keeps a 20-person test registration cache. It synchronizes the cloud registry periodically and immediately retries a registry refresh when a locally unknown UID is scanned. The cache is persisted in LittleFS so a temporary Internet outage does not erase the local registry.

## Offline behavior
Attendance status and history writes are placed in a LittleFS cloud queue when the cloud is unavailable. The machine continues RFID processing. The queue is uploaded when Firebase connectivity returns.

## Email behavior
The ESP only creates notification queue jobs. EmailJS is handled by the dashboard worker. Failed jobs remain available for retry; old successful jobs may be cleaned up.

## Security
Firebase Authentication is required. Dashboard roles are enforced by Realtime Database rules. The device uses its own Firebase Authentication account and must be registered under `devices/{deviceAuthUid}` with `active: true`.

## Important
Firebase Realtime Database rules cannot securely determine whether an arbitrary Firebase Authentication account was manually deleted. Keep at least one owner/admin recovery account and manage emergency recovery in Firebase Console.

## Hosting deployment fix — October 2026

The package now uses a **root-level firebase.json** with:

```json
"hosting": {
  "public": "dashboard"
}
```

This removes ambiguity about the Hosting public directory and prevents deploying the generated Firebase welcome page from a separate `public/` directory.

Always run Firebase CLI commands from the `Smart_Attendance_V8_FINAL` project root.
