#!/bin/bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter build windows
flutter pub run msix:create