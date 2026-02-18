import 'package:flutter/material.dart';

import '../utils/general_utils.dart';


class Country {
  final String name;
  final String code;
  final String flag;
  final String capital;
  final String continent;

  const Country({
    required this.name,
    required this.code,
    required this.flag,
    required this.capital,
    required this.continent,
  });
}

enum CountrySelectorStyle {
  bottomSheet,
  dropdown,
  dialog,
  page,
}

class CountrySelector extends StatefulWidget {
  final Country? selectedCountry;
  final Function(Country) onCountrySelected;
  final CountrySelectorStyle style;
  final String? hintText;
  final bool showSearch;
  final bool showFlag;
  final bool showCapital;
  final List<String>? favoriteCountryCodes;
  final Color? primaryColor;
  final List<Country> countries;

  const CountrySelector({
    Key? key,
    this.selectedCountry,
    required this.onCountrySelected,
    this.style = CountrySelectorStyle.bottomSheet,
    this.hintText,
    this.showSearch = true,
    this.showFlag = true,
    this.showCapital = false,
    this.favoriteCountryCodes,
    this.primaryColor,
    this.countries = GeneralUtils.defaultCountries,
  }) : super(key: key);



  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  Color get primaryColor => widget.primaryColor ?? Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showCountrySelector,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (widget.showFlag && widget.selectedCountry != null) ...[
              Text(
                widget.selectedCountry!.flag,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                widget.selectedCountry?.name ?? widget.hintText ?? "Select Country",
                style: TextStyle(
                  fontSize: 16,
                  color: widget.selectedCountry != null
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                radius: 20,
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showCountrySelector() {
    switch (widget.style) {
      case CountrySelectorStyle.bottomSheet:
        _showBottomSheet();
        break;
      case CountrySelectorStyle.dropdown:
        _showDropdown();
        break;
      case CountrySelectorStyle.dialog:
        _showDialog();
        break;
      case CountrySelectorStyle.page:
        _navigateToPage();
        break;
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _CountryListView(
        countries: widget.countries,
        onCountrySelected: widget.onCountrySelected,
        showSearch: widget.showSearch,
        showFlag: widget.showFlag,
        showCapital: widget.showCapital,
        favoriteCountryCodes: widget.favoriteCountryCodes,
        primaryColor: primaryColor,
        title: "Select Country",
        isBottomSheet: true,
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _CountryListView(
          countries: widget.countries,
          onCountrySelected: (country) {
            widget.onCountrySelected(country);
            Navigator.pop(context);
          },
          showSearch: widget.showSearch,
          showFlag: widget.showFlag,
          showCapital: widget.showCapital,
          favoriteCountryCodes: widget.favoriteCountryCodes,
          primaryColor: primaryColor,
          title: "Select Country",
          isBottomSheet: false,
        ),
      ),
    );
  }

  void _showDropdown() {
    // This would typically use a proper dropdown implementation
    _showBottomSheet(); // Fallback to bottom sheet for simplicity
  }

  void _navigateToPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountrySelectionPage(
          countries: widget.countries,
          onCountrySelected: widget.onCountrySelected,
          showSearch: widget.showSearch,
          showFlag: widget.showFlag,
          showCapital: widget.showCapital,
          favoriteCountryCodes: widget.favoriteCountryCodes,
          primaryColor: primaryColor,
        ),
      ),
    );
  }
}

class _CountryListView extends StatefulWidget {
  final List<Country> countries;
  final Function(Country) onCountrySelected;
  final bool showSearch;
  final bool showFlag;
  final bool showCapital;
  final List<String>? favoriteCountryCodes;
  final Color primaryColor;
  final String title;
  final bool isBottomSheet;

  const _CountryListView({
    required this.countries,
    required this.onCountrySelected,
    required this.showSearch,
    required this.showFlag,
    required this.showCapital,
    this.favoriteCountryCodes,
    required this.primaryColor,
    required this.title,
    required this.isBottomSheet,
  });

  @override
  State<_CountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<_CountryListView> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = [];
  List<Country> _favoriteCountries = [];

  @override
  void initState() {
    super.initState();
    _initializeCountries();
  }

  void _initializeCountries() {
    _filteredCountries = widget.countries;
    if (widget.favoriteCountryCodes != null) {
      _favoriteCountries = widget.countries
          .where((country) => widget.favoriteCountryCodes!.contains(country.code))
          .toList();
    }
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries.where((country) {
          return country.name.toLowerCase().contains(query.toLowerCase()) ||
              country.code.toLowerCase().contains(query.toLowerCase()) ||
              country.capital.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.isBottomSheet
        ? MediaQuery.of(context).size.height * 0.75
        : MediaQuery.of(context).size.height * 0.6;

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (widget.isBottomSheet) ...[
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (widget.showSearch) ...[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search countries...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: _filterCountries,
            ),
            const SizedBox(height: 16),
          ],

          Expanded(
            child: ListView(
              children: [
                if (_favoriteCountries.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Favorites",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ),
                  ..._favoriteCountries.map((country) => _buildCountryTile(country)),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "All Countries",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                ..._filteredCountries.map((country) => _buildCountryTile(country)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryTile(Country country) {
    return ListTile(
      leading: widget.showFlag
          ? Text(country.flag, style: const TextStyle(fontSize: 24))
          : null,
      title: Text(country.name, style: TextStyle(color: Colors.white),),
      subtitle: widget.showCapital ? Text(country.capital) : null,
      trailing: Text(
        country.code,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        widget.onCountrySelected(country);
        if (widget.isBottomSheet) Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CountrySelectionPage extends StatelessWidget {
  final List<Country> countries;
  final Function(Country) onCountrySelected;
  final bool showSearch;
  final bool showFlag;
  final bool showCapital;
  final List<String>? favoriteCountryCodes;
  final Color primaryColor;

  const CountrySelectionPage({
    Key? key,
    required this.countries,
    required this.onCountrySelected,
    required this.showSearch,
    required this.showFlag,
    required this.showCapital,
    this.favoriteCountryCodes,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Country"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _CountryListView(
        countries: countries,
        onCountrySelected: (country) {
          onCountrySelected(country);
          Navigator.pop(context);
        },
        showSearch: showSearch,
        showFlag: showFlag,
        showCapital: showCapital,
        favoriteCountryCodes: favoriteCountryCodes,
        primaryColor: primaryColor,
        title: "",
        isBottomSheet: false,
      ),
    );
  }
}
//
// // Demo widget
// class CountrySelectorDemo extends StatefulWidget {
//   @override
//   _CountrySelectorDemoState createState() => _CountrySelectorDemoState();
// }
//
// class _CountrySelectorDemoState extends State<CountrySelectorDemo> {
//   Country? _selectedCountry;
//   CountrySelectorStyle _style = CountrySelectorStyle.bottomSheet;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Country Selector Demo"),
//         backgroundColor: Colors.teal,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Select Style:",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 8,
//               children: CountrySelectorStyle.values.map((style) {
//                 return ChoiceChip(
//                   label: Text(_getStyleName(style)),
//                   selected: _style == style,
//                   onSelected: (_) {
//                     setState(() {
//                       _style = style;
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 32),
//
//             const Text(
//               "Select Country:",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             CountrySelector(
//               selectedCountry: _selectedCountry,
//               onCountrySelected: (country) {
//                 setState(() {
//                   _selectedCountry = country;
//                 });
//               },
//               style: _style,
//               hintText: "Choose your country",
//               showSearch: true,
//               showFlag: true,
//               showCapital: true,
//               favoriteCountryCodes: const ['US', 'GB', 'MY', 'SG', 'IN'],
//               primaryColor: Colors.teal,
//             ),
//             const SizedBox(height: 32),
//
//             if (_selectedCountry != null)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.teal.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.teal.shade200),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           _selectedCountry!.flag,
//                           style: const TextStyle(fontSize: 32),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _selectedCountry!.name,
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "Capital: ${_selectedCountry!.capital}",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                 ),
//                               ),
//                               Text(
//                                 "Code: ${_selectedCountry!.code}",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                 ),
//                               ),
//                               Text(
//                                 "Continent: ${_selectedCountry!.continent}",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getStyleName(CountrySelectorStyle style) {
//     switch (style) {
//       case CountrySelectorStyle.bottomSheet:
//         return "Bottom Sheet";
//       case CountrySelectorStyle.dropdown:
//         return "Dropdown";
//       case CountrySelectorStyle.dialog:
//         return "Dialog";
//       case CountrySelectorStyle.page:
//         return "Full Page";
//     }
//   }
// }