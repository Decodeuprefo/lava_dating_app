import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GoogleSignInScreen(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        final user = await _googleSignIn.signInSilently();
        setState(() => _currentUser = user);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final user = await _googleSignIn.signIn();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome ${user.displayName}!')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $e')),
      );
      print('Sign-in error: $e');
    }
  }

  Future<void> _handleGoogleSignOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() => _currentUser = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-out failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign-In')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _currentUser == null
            ? _buildSignInUI()
            : _buildUserUI(),
      ),
    );
  }

  Widget _buildSignInUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_circle, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _handleGoogleSignIn,
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildUserUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentUser?.photoUrl != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_currentUser!.photoUrl!),
          ),
        const SizedBox(height: 24),
        Text(
          _currentUser?.displayName ?? 'User',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(_currentUser?.email ?? ''),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _handleGoogleSignOut,
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }
}