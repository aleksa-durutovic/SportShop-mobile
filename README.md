# SportShop Mobile

Flutter mobilna aplikacija za kupovinu sportskih suplemenata, povezana sa Laravel REST API backend-om.

## Funkcionalnosti

- Registracija i prijava korisnika
- Logout korisnika
- Pregled proizvoda
- Dodavanje proizvoda u korpu
- Brisanje stavki iz korpe
- Checkout (kreiranje porudžbine)
- Prikaz korisničkih porudžbina na profilu
- Brisanje porudžbine

## Tehnologije

### Frontend
- Flutter (Dart)
- go_router
- dio
- flutter_secure_storage

### Backend
- Laravel
- Laravel Sanctum
- REST API

## API endpoint-i

### Auth
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`
- `POST /api/auth/logout`

### Products
- `GET /api/products`
- `GET /api/products/{id}`

### Orders
- `GET /api/orders`
- `POST /api/orders`
- `DELETE /api/orders/{id}`

## Pokretanje

### Backend
```bash
cd C:\Users\AleksA\StudioProjects\sport-shop-backend
php artisan optimize:clear
php artisan serve --host=0.0.0.0 --port=8000
```

### Frontend
```bash
cd C:\Users\AleksA\StudioProjects\projekat
flutter clean
flutter pub get
flutter run
```

## Napomena za Android emulator

U `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

## Autor

Aleksa Durutovic
