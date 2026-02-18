import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/general_utils.dart';


class CountryPrefixCode {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  CountryPrefixCode({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });
}

class IntegratedPhoneNumberField extends StatefulWidget {
  final Function(CountryPrefixCode) onCountrySelected;
  final Function(String)? onPhoneChanged;
  final CountryPrefixCode? selectedCountry;
  final TextEditingController? phoneController;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool readOnly;

  const IntegratedPhoneNumberField({
    Key? key,
    required this.onCountrySelected,
    this.onPhoneChanged,
    this.selectedCountry,
    this.phoneController,
    this.hintText = "Phone number",
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<IntegratedPhoneNumberField> createState() =>
      _IntegratedPhoneNumberFieldState();
}

class _IntegratedPhoneNumberFieldState
    extends State<IntegratedPhoneNumberField> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryPrefixCode> _filteredCountriesPrefixCode = [];
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _filteredCountriesPrefixCode = GeneralUtils.countryPrefixCodes;
    _phoneController = widget.phoneController ?? TextEditingController();
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountriesPrefixCode = GeneralUtils.countryPrefixCodes;
      } else {
        _filteredCountriesPrefixCode = GeneralUtils.countryPrefixCodes.where((
            country,
            ) {
          return country.name.toLowerCase().contains(query.toLowerCase()) ||
              country.dialCode.contains(query) ||
              country.code.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: widget.onPhoneChanged,
      style: const TextStyle(fontSize: 14, color: Colors.white),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        errorStyle: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(color: Colors.red),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.transparent,
            // width: 2,
          ),
        ),
        // errorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(30),
        //   borderSide: const BorderSide(
        //
        //     width: 2,
        //   ),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            // color: Colors.transparent,
            width: 2,
          ),
        ),

        prefixIcon: InkWell(
          onTap: () => _showCountryPicker(context),
          borderRadius: BorderRadius.horizontal(left: Radius.circular(25)),
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 16),
                Text(
                  widget.selectedCountry?.flag ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.selectedCountry?.dialCode ?? "+00",
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.selectedCountry != null
                        ? Colors.white
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Transform.rotate(
                    angle: 90 * 3.1415927 / 180,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(height: 15, width: 1, color: Colors.white),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    // context.read<AuthManager>().BNBInvisible();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Country",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear, color: Colors.white),
                    style: ButtonStyle(
                      iconSize: WidgetStatePropertyAll(20),
                      iconColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search country or code...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  _filterCountries(value);
                  setModalState(() {});
                },
              ),
              const SizedBox(height: 16),
              // Countries list
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCountriesPrefixCode.length,
                  itemBuilder: (context, index) {
                    final country = _filteredCountriesPrefixCode[index];
                    return ListTile(
                      leading: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        country.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        country.dialCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        widget.onCountrySelected(country);
                        _searchController.clear();
                        _filteredCountriesPrefixCode =
                            GeneralUtils.countryPrefixCodes;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      if (context.mounted) {
        // context.read<AuthManager>().BNBVisible();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (widget.phoneController == null) {
      _phoneController.dispose();
    }
    super.dispose();
  }
}

// Example usage widget
class PhoneNumberInput extends StatefulWidget {
  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  CountryPrefixCode? _selectedCountry;
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Number Input")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your phone number:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            IntegratedPhoneNumberField(
              selectedCountry: _selectedCountry,
              phoneController: _phoneController,
              onCountrySelected: (country) {
                setState(() {
                  _selectedCountry = country;
                });
              },
              onPhoneChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                if (_selectedCountry == null) {
                  return 'Please select a country code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (_selectedCountry != null && _phoneController.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Complete number: ${_selectedCountry!.dialCode} ${_phoneController.text}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
