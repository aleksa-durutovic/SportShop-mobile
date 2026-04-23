import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'data/services/auth_service.dart';
import 'data/services/order_service.dart';
import 'data/state/cart_state.dart';

void main() {
  runApp(const MyApp());
}

/// ROUTES
class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/';
  static const productDetails = '/product-details';
  static const cart = '/cart';
  static const profile = '/profile';
}

typedef ProductMap = Map<String, String>;

/// ROUTER
final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      builder: (context, state) {
        final product = state.extra as ProductMap?;
        if (product == null) return const HomeScreen();
        return ProductDetailsScreen(product: product);
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sport Shop Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

/// LOGIN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    setState(() => _loading = true);
    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login greška: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prijava')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Lozinka',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _onLogin,
                child: _loading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Prijavi se'),
              ),
            ),
            TextButton(
              onPressed: _loading ? null : () => context.go(AppRoutes.register),
              child: const Text('Nemaš nalog? Registruj se'),
            ),
          ],
        ),
      ),
    );
  }
}

/// REGISTER
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    setState(() => _loading = true);
    try {
      await _authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
      );
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register greška: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registracija')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ime',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Lozinka',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Potvrdi lozinku',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _onRegister,
                child: _loading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Registruj se'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HOME
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProductMap> products = [
      {
        'name': 'Whey Protein 2kg',
        'desc': 'Visok procenat proteina za oporavak i rast mišića.',
        'price': '4,990 RSD',
        'image': 'assets/images/protein.jfif',
      },
      {
        'name': 'Creatine Monohydrate',
        'desc': 'Povećava snagu i performanse na treningu.',
        'price': '1,990 RSD',
        'image': 'assets/images/creatine.png',
      },
      {
        'name': 'BCAA 4:1:1',
        'desc': 'Amino kiseline za brži oporavak.',
        'price': '2,490 RSD',
        'image': 'assets/images/bcaa.png',
      },
      {
        'name': 'Pre-Workout',
        'desc': 'Energija i fokus pre treninga.',
        'price': '2,290 RSD',
        'image': 'assets/images/preworkout.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sport Shop'),
        actions: [
          IconButton(
            onPressed: () => context.go(AppRoutes.cart),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () => context.go(AppRoutes.profile),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final p = products[index];
          return ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                p['image']!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            title: Text(p['name']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(p['desc']!),
                const SizedBox(height: 4),
                Text(
                  p['price']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push(AppRoutes.productDetails, extra: p),
          );
        },
      ),
    );
  }
}

/// PRODUCT DETAILS
class ProductDetailsScreen extends StatelessWidget {
  final ProductMap product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text('Detalji proizvoda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                product['image']!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product['name']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(product['desc']!),
            const SizedBox(height: 12),
            Text('Cena: ${product['price']!}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final rawPrice = product['price'] ?? '0';
                  final numeric = rawPrice.replaceAll(RegExp(r'[^0-9]'), '');
                  final price = int.tryParse(numeric) ?? 0;

                  CartState.instance.addItem(
                    name: product['name'] ?? 'Proizvod',
                    desc: product['desc'] ?? '',
                    image: product['image'] ?? '',
                    price: price,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dodato u korpu')),
                  );
                },
                child: const Text('Dodaj u korpu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CART
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cart = CartState.instance;
  final OrderService _orderService = OrderService();
  bool _placing = false;

  @override
  void initState() {
    super.initState();
    cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _checkout() async {
    if (cart.items.isEmpty) return;
    setState(() => _placing = true);
    try {
      await _orderService.createOrder(totalPrice: cart.total, status: 'processing');
      cart.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Porudžbina je uspešno kreirana.')),
      );
      context.go(AppRoutes.profile);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri checkout-u: $e')),
      );
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String rsd(int value) => '$value RSD';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text('Korpa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (cart.items.isEmpty)
              const Expanded(
                child: Center(child: Text('Korpa je prazna.')),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final item = cart.items[i];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Količina: ${item.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(rsd(item.price * item.quantity)),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: 'Ukloni iz korpe',
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                cart.removeItem(item.name);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            Text(
              'Ukupno: ${rsd(cart.total)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_placing || cart.items.isEmpty) ? null : _checkout,
                child: _placing
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Nastavi na plaćanje'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PROFILE
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final OrderService _orderService = OrderService();

  late Future<Map<String, dynamic>> _meFuture;
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  bool _logoutLoading = false;

  @override
  void initState() {
    super.initState();
    _meFuture = _authService.me();
    _ordersFuture = _orderService.getMyOrders();
  }

  Future<void> _logout() async {
    setState(() => _logoutLoading = true);
    try {
      await _authService.logout();
    } catch (_) {
      await _authService.clearToken();
    } finally {
      if (!mounted) return;
      setState(() => _logoutLoading = false);
      context.go(AppRoutes.login);
    }
  }

  Future<void> _deleteOrder(dynamic id) async {
    final orderId = int.tryParse(id.toString());
    if (orderId == null) return;

    try {
      await _orderService.deleteOrder(orderId);
      if (!mounted) return;
      setState(() {
        _ordersFuture = _orderService.getMyOrders();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Porudžbina obrisana.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri brisanju porudžbine: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text('Profil'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_meFuture, _ordersFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Greška pri učitavanju profila: ${snapshot.error}'),
            );
          }

          final user = (snapshot.data?[0] as Map<String, dynamic>?) ?? {};
          final orders = (snapshot.data?[1] as List<Map<String, dynamic>>?) ?? [];

          final name = (user['name'] ?? 'Nepoznato').toString();
          final email = (user['email'] ?? 'Nepoznato').toString();

          String formatDate(String? iso) {
            if (iso == null || iso.isEmpty) return '-';
            final dt = DateTime.tryParse(iso);
            if (dt == null) return iso;
            return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
          }

          String formatPrice(dynamic value) {
            final n = double.tryParse(value.toString()) ?? 0;
            return '${n.toStringAsFixed(0)} RSD';
          }

          String formatStatus(dynamic status) {
            final s = (status ?? '').toString().toLowerCase();
            switch (s) {
              case 'pending':
                return 'Na čekanju';
              case 'processing':
                return 'U obradi';
              case 'completed':
                return 'Završena';
              case 'cancelled':
                return 'Otkazana';
              default:
                return status?.toString() ?? '-';
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Korisnički podaci',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('Ime: $name', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 6),
                      Text('Email: $email', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Moje porudžbine',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (orders.isEmpty)
                const Text('Nema porudžbina.')
              else
                ...orders.map(
                      (o) => Card(
                    child: ListTile(
                      title: Text('Porudžbina #${o['id']}'),
                      subtitle: Text(
                        '${formatDate(o['created_at']?.toString())} • ${formatStatus(o['status'])}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(formatPrice(o['total_price'])),
                          IconButton(
                            tooltip: 'Obriši porudžbinu',
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _deleteOrder(o['id']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logoutLoading ? null : _logout,
                  icon: _logoutLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.logout),
                  label: Text(_logoutLoading ? 'Odjavljivanje...' : 'Odjavi se'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}