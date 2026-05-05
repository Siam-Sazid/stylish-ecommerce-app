import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  int _selectedPayment = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final checkout = Get.find<CheckoutController>();
    final auth = Get.find<AuthController>();

    return Obx(() {
      if (checkout.paymentSuccess.value) {
        return _SuccessView();
      }
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: AppColors.surface,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      ...cart.cartItems.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} x${item.quantity}',
                                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                  ),
                                ),
                                Text(
                                  '\$${item.total.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                ),
                              ],
                            ),
                          )),
                      const Divider(),
                      _CheckoutRow(label: 'Subtotal', value: '\$${cart.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 4),
                      _CheckoutRow(
                        label: 'Shipping',
                        value: cart.shipping == 0 ? 'FREE' : '\$${cart.shipping.toStringAsFixed(2)}',
                        valueColor: cart.shipping == 0 ? AppColors.success : null,
                      ),
                      const Divider(),
                      _CheckoutRow(
                        label: 'Total',
                        value: '\$${cart.total.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Shipping information
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shipping Information', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameCtrl..text = auth.currentUser.value?.name ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Street Address',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityCtrl,
                              decoration: const InputDecoration(labelText: 'City'),
                              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _zipCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'ZIP Code'),
                              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Payment method
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Method', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      _PaymentOption(
                        index: 0,
                        selected: _selectedPayment,
                        icon: Icons.credit_card_rounded,
                        label: 'Credit / Debit Card',
                        sublabel: 'Powered by Stripe',
                        onTap: () => setState(() => _selectedPayment = 0),
                      ),
                      const SizedBox(height: 8),
                      _PaymentOption(
                        index: 1,
                        selected: _selectedPayment,
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'PayPal',
                        sublabel: 'Fast & secure',
                        onTap: () => setState(() => _selectedPayment = 1),
                      ),
                      const SizedBox(height: 8),
                      _PaymentOption(
                        index: 2,
                        selected: _selectedPayment,
                        icon: Icons.local_shipping_outlined,
                        label: 'Cash on Delivery',
                        sublabel: 'Pay when you receive',
                        onTap: () => setState(() => _selectedPayment = 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: checkout.isProcessing.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  checkout.processPayment(
                                    amount: cart.total,
                                    email: auth.currentUser.value?.email ?? '',
                                  );
                                }
                              },
                        child: checkout.isProcessing.value
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Processing Payment...'),
                                ],
                              )
                            : Text(
                                'Pay \$${cart.total.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                      ),
                    )),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 14, color: AppColors.textHint),
                    SizedBox(width: 4),
                    Text(
                      'Payments are secured with SSL encryption',
                      style: TextStyle(color: AppColors.textHint, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    });
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      );
}

class _CheckoutRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? valueColor;

  const _CheckoutRow({required this.label, required this.value, this.isTotal = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: isTotal ? AppColors.text : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? (isTotal ? AppColors.primary : AppColors.text),
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final int index;
  final int selected;
  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.index,
    required this.selected,
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.text, fontSize: 14)),
                  Text(sublabel, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, size: 60, color: AppColors.success),
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Placed!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your order has been placed successfully.\nYou\'ll receive a confirmation email shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/main'),
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
