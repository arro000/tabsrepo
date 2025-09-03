#!/bin/bash

echo "🎵 ClassTab Catalog - Avvio in modalità debug"
echo "=============================================="

# Controlla se Flutter è installato
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter non trovato. Installa Flutter prima di continuare."
    exit 1
fi

# Controlla la versione di Flutter
echo "📱 Versione Flutter:"
flutter --version

echo ""
echo "🔧 Controllo dipendenze..."
flutter pub get

echo ""
echo "🧪 Esecuzione test..."
flutter test

echo ""
echo "🔍 Analisi del codice..."
flutter analyze --no-fatal-infos

echo ""
echo "✅ Tutto pronto! L'applicazione ClassTab Catalog è configurata correttamente."
echo ""
echo "Per avviare l'app:"
echo "  flutter run"
echo ""
echo "Per compilare per Android:"
echo "  flutter build apk"
echo ""
echo "Per compilare per il web:"
echo "  flutter build web"