# Flutter Clean Architecture BLoC Template

This repository is a **Flutter project template** based on **Clean Architecture + BLoC**.

The template is meant to be **cloned and initialized**.
Do NOT use it directly without running the initialization steps.

---

## After cloning, you MUST init project (by help of init_project.sh file in root folder)


## STEP 1  Run this command in terminal in root directory
1. chmod +x init_project.sh
2. ./init_project.sh "My App" com.company.myapp

--------------------------------------------
What this script does internally:

1. Removes template Git history
    rm -rf .git
2. Installs the rename tool (if missing)
    dart pub global activate rename
    This tool safely updates app name and bundle identifiers across all platforms.
3. Sets application name
    Android app label
    iOS display name
    Web / Desktop (if enabled)
4. Sets bundle identifiers
    Android applicationId
    iOS PRODUCT_BUNDLE_IDENTIFIER
5. Downloads dependencies
    flutter pub get
-------------------------------------------
## STEP 2 Verify configuration (optional but recommended)
Check pubspec.yaml:
name: my_app
Check Android:

# android/app/build.gradle → applicationId

# android/app/src/main/kotlin/.../MainActivity.kt -> applicationId  (first line com.example.id)

# android/app/src/main/AndroidManifest.xml → app label

Check iOS:

# ios/Runner/Info.plist → CFBundleDisplayName

# Xcode project → Bundle Identifier

If init_project.sh ran successfully, no manual edits are required.

## STEP 3 Remove pubspec.lock from gitignore

## STEP 4 — Change root folder name and all imports
# copy this command and paste change my_app  
grep -rl "package:bloc_clean_architecture_template" lib \
| xargs sed -i '' 's/package:bloc_clean_architecture_template/package:b2b_seller/g'


## STEP 5 — Create a new Git repository
git init
git remote add origin ...
git add .
git branch -M main
git add .
git commit -m "init"
git push -u origin main

## STEP 6 Create .env file like .env.example

## STEP 7 — Run the application

## STEP 8 Initialize fvm if you want 
