Aquí tienes la documentación para GitHub sobre cómo ejecutar el proyecto en tu máquina local. 📄🚀  

---

# **🛍 Tienda Bloc - Documentación de Instalación y Ejecución**

### 📌 **Descripción del Proyecto**
Tienda Bloc es una aplicación de comercio electrónico desarrollada en **Flutter** con **BLoC** como manejador de estado y **Firebase** como backend. Permite la gestión de productos, carrito de compras y autenticación con Google y correo electrónico.

---

## **📥 1. Requisitos Previos**
Antes de ejecutar el proyecto, asegúrate de tener instaladas las siguientes herramientas:

✅ **Flutter** (versión recomendada: `>=3.10.0`)  
✅ **Dart** (se instala con Flutter)  
✅ **Firebase CLI** (para configurar Firebase)  
✅ **Android Studio** o **Visual Studio Code** (opcional pero recomendado)  
✅ **Git** (para clonar el repositorio)  

---

## **📌 2. Clonar el Repositorio**
Ejecuta el siguiente comando en la terminal:

```sh
git clone https://github.com/tu-usuario/tienda_bloc.git
cd tienda_bloc
```

---

## **⚙ 3. Configurar Firebase**
1️⃣ **Accede a [Firebase Console](https://console.firebase.google.com/)** y crea un nuevo proyecto.  
2️⃣ **Agrega una aplicación Android y iOS** con los siguientes paquetes:
   - Android: `com.example.tiendaBloc`
   - iOS: `com.example.tiendaBloc`
3️⃣ **Descarga el archivo `google-services.json`** y colócalo en:
   ```
   android/app/google-services.json
   ```
4️⃣ **Descarga el archivo `GoogleService-Info.plist`** y colócalo en:
   ```
   ios/Runner/GoogleService-Info.plist
   ```
5️⃣ **Habilita Firestore y Authentication en Firebase Console:**
   - **Firestore Database** (Modo producción o prueba)
   - **Authentication** (Correo y Google Sign-In)

6️⃣ **Ejecuta el siguiente comando para inicializar Firebase en el proyecto:**
   ```sh
   flutterfire configure
   ```

---

## **🚀 4. Instalar Dependencias**
Ejecuta este comando en la raíz del proyecto:

```sh
flutter pub get
```

---

## **📌 5. Ejecutar la Aplicación**
Para iniciar la aplicación en un emulador o dispositivo físico, usa:

```sh
flutter run
```

Si deseas ejecutar en **Android** específicamente:

```sh
flutter run -d android
```

Para **iOS** (requiere macOS y Xcode):

```sh
flutter run -d ios
```

---

## **🛠 6. Estructura del Proyecto**
```
📦 tienda_bloc
 ┣ 📂 android
 ┣ 📂 ios
 ┣ 📂 lib
 ┃ ┣ 📂 config
 ┃ ┃ ┗ 📜 routes.dart
 ┃ ┣ 📂 features
 ┃ ┃ ┣ 📂 authentication
 ┃ ┃ ┃ ┣ 📂 data
 ┃ ┃ ┃ ┣ 📂 domain
 ┃ ┃ ┃ ┣ 📂 presentation
 ┃ ┃ ┣ 📂 cart
 ┃ ┃ ┃ ┣ 📂 data
 ┃ ┃ ┃ ┣ 📂 domain
 ┃ ┃ ┃ ┣ 📂 presentation
 ┃ ┃ ┣ 📂 product
 ┃ ┃ ┃ ┣ 📂 data
 ┃ ┃ ┃ ┣ 📂 domain
 ┃ ┃ ┃ ┣ 📂 presentation
 ┃ ┗ 📜 main.dart
 ┣ 📜 pubspec.yaml
 ┗ 📜 README.md
```

---

## **📌 7. Variables de Entorno**
Si usas **Firebase Functions** o **APIs externas**, crea un archivo `.env` en la raíz del proyecto:

```
API_KEY=tu_api_key
AUTH_DOMAIN=tu_auth_domain
PROJECT_ID=tu_project_id
STORAGE_BUCKET=tu_storage_bucket
MESSAGING_SENDER_ID=tu_messaging_id
APP_ID=tu_app_id
```

Y agrégalo en `pubspec.yaml` con:

```yaml
dependencies:
  flutter_dotenv: ^5.0.2
```

Cárgalo en `main.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
}
```

---

## **✅ 8. Funcionalidades Principales**
✔ **Autenticación con Google y Email/Contraseña**  
✔ **Ver catálogo de productos**  
✔ **Agregar productos al carrito**  
✔ **Eliminar productos del carrito**  
✔ **Modificar cantidad de productos en el carrito**  
✔ **Persistencia en Firebase Firestore**  
✔ **Manejo de estados con BLoC**  

---

## **📌 9. Contribuir al Proyecto**
Si deseas contribuir, sigue estos pasos:

1️⃣ **Haz un fork del repositorio**  
2️⃣ **Crea una rama con tu nueva funcionalidad:**
   ```sh
   git checkout -b nueva-funcionalidad
   ```
3️⃣ **Realiza los cambios y haz un commit:**
   ```sh
   git commit -m "Agregada nueva funcionalidad"
   ```
4️⃣ **Sube los cambios a tu fork:**
   ```sh
   git push origin nueva-funcionalidad
   ```
5️⃣ **Crea un Pull Request en GitHub** 🚀  

---

## **📌 10. Problemas y Soporte**
Si encuentras un error o necesitas ayuda, abre un **issue** en GitHub o contacta al equipo de desarrollo.  

---

📌 **Autor:** Yannyer Peñalo
📌 **Repositorio:** [GitHub Repo URL]  
📌 **Licencia:** MIT  
