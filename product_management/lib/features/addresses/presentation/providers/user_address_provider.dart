import 'package:flutter/material.dart';
import '../../domain/entities/user_address_entity.dart';
import '../../domain/usecases/address_usecases.dart';

class UserAddressProvider extends ChangeNotifier {
  final GetUserAddressesUseCase _getUserAddressesUseCase;
  final CreateAddressUseCase _createAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  UserAddressProvider(
    this._getUserAddressesUseCase,
    this._createAddressUseCase,
    this._updateAddressUseCase,
    this._deleteAddressUseCase,
  );

  List<UserAddress> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserAddress> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserAddress? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      if (_addresses.isNotEmpty) return _addresses.first;
      return null;
    }
  }

  Future<void> fetchAddresses(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _addresses = await _getUserAddressesUseCase(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createAddress(UserAddress address) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _createAddressUseCase(address);
      await fetchAddresses(address.userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAddress(int id, UserAddress address) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateAddressUseCase(id, address);
      await fetchAddresses(address.userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAddress(int id, int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _deleteAddressUseCase(id);
      await fetchAddresses(userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
