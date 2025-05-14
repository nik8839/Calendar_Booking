import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CalendarBookingApp());
}

class CalendarBookingApp extends StatelessWidget {
  const CalendarBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Booking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BookingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _bookingIdController = TextEditingController();

  DateTime? _selectedStartDate;
  TimeOfDay? _selectedStartTime;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedEndTime;

  String _responseMessage = "";
  String _bookingById = "";
  List<dynamic> _allBookings = [];
  bool _isViewAll =
      false; // Track whether we should view all bookings or a specific booking by ID

  // Combine date and time
  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // Method for creating a booking
  Future<void> _createBooking() async {
    if (_userIdController.text.isEmpty ||
        _selectedStartDate == null ||
        _selectedStartTime == null ||
        _selectedEndDate == null ||
        _selectedEndTime == null) {
      setState(() {
        _responseMessage = "Please fill all fields.";
      });
      return;
    }

    final startDateTime = _combineDateTime(
      _selectedStartDate!,
      _selectedStartTime!,
    );
    final endDateTime = _combineDateTime(_selectedEndDate!, _selectedEndTime!);

    // final url = Uri.parse('http://localhost:5000/bookings');
    final url = Uri.parse('https://calendarbooking-production.up.railway.app/bookings');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": _userIdController.text.trim(),
          "startTime": startDateTime.toUtc().toIso8601String(),
          "endTime": endDateTime.toUtc().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _responseMessage = "Booking created successfully.";
        });
      } else {
        setState(() {
          _responseMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = "Connection failed. $e";
      });
    }
  }

  // Fetch booking by ID
  Future<void> _getBookingById() async {
    if (_bookingIdController.text.isEmpty) {
      setState(() {
        _bookingById = "Booking ID is required.";
      });
      return;
    }

    final url = Uri.parse(
      'http://localhost:5000/bookings/${_bookingIdController.text.trim()}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _bookingById = _formatBookingDetails(data);
        });
      } else {
        setState(() {
          _bookingById =
              "Booking not found. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _bookingById = "Connection failed. $e";
      });
    }
  }

  // Fetch all bookings
  Future<void> _getAllBookings() async {
    final url = Uri.parse('http://localhost:5000/bookings');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _allBookings = data;
        });
      } else {
        setState(() {
          _allBookings = [];
        });
      }
    } catch (e) {
      setState(() {
        _allBookings = [];
      });
    }
  }

  // Format booking details to show in a user-friendly way
  String _formatBookingDetails(Map<String, dynamic> booking) {
    return """
      User ID: ${booking['userId']}
      Start Time: ${DateTime.parse(booking['startTime']).toLocal()}
      End Time: ${DateTime.parse(booking['endTime']).toLocal()}
    """;
  }

  // Toggle between viewing all bookings or booking by ID
  void _toggleView(bool isViewAll) {
    setState(() {
      _isViewAll = isViewAll;
    });
    if (isViewAll) {
      _getAllBookings(); // Fetch all bookings when toggling to "View All"
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _bookingIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Create booking form
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            SizedBox(height: 16),

            // Start Date & Time Pickers
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: Text(
                    _selectedStartDate == null
                        ? 'Pick Start Date'
                        : _selectedStartDate!.toLocal().toString().split(
                          ' ',
                        )[0],
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _pickTime(isStart: true),
                  child: Text(
                    _selectedStartTime == null
                        ? 'Pick Start Time'
                        : _selectedStartTime!.format(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Add padding between start and end pickers
            // End Date & Time Pickers
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickDate(isStart: false),
                  child: Text(
                    _selectedEndDate == null
                        ? 'Pick End Date'
                        : _selectedEndDate!.toLocal().toString().split(' ')[0],
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _pickTime(isStart: false),
                  child: Text(
                    _selectedEndTime == null
                        ? 'Pick End Time'
                        : _selectedEndTime!.format(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createBooking,
              child: Text("Create Booking"),
            ),
            SizedBox(height: 20),
            Text(
              _responseMessage,
              style: TextStyle(
                color:
                    _responseMessage.contains("success")
                        ? Colors.green
                        : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),

            // Toggle button to switch between "View All" and "View by ID"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _toggleView(true),
                  child: Text("View All Bookings"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _toggleView(false),
                  child: Text("View Booking by ID"),
                ),
              ],
            ),

            // If viewing by ID
            if (!_isViewAll) ...[
              TextField(
                controller: _bookingIdController,
                decoration: InputDecoration(labelText: 'Booking ID'),
              ),
              ElevatedButton(
                onPressed: _getBookingById,
                child: Text("Get Booking by ID"),
              ),
              Text(_bookingById),
            ],
        SizedBox(height: 16),
            // If viewing all bookings
            if (_isViewAll) ...[
              ElevatedButton(
                onPressed: _getAllBookings,
                child: Text("Get All Bookings"),
              ),
              // Display all bookings in a ListView
              if (_allBookings.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _allBookings.map<Widget>((booking) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('Booking ID: ${booking['id']}'),
                            subtitle: Text(
                              'User ID: ${booking['userId']}\n'
                              'Start: ${DateTime.parse(booking['startTime']).toLocal()} - End: ${DateTime.parse(booking['endTime']).toLocal()}',
                            ),
                          ),
                        );
                      }).toList(),
                )
              else
                Text('No bookings available'),
            ],

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Utility method to format the datetime for display
  String _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return 'Not selected';
    final combined = _combineDateTime(date, time);
    return combined.toLocal().toString();
  }

  // Pick date method
  Future<void> _pickDate({required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  // Pick time method
  Future<void> _pickTime({required bool isStart}) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _selectedStartTime = pickedTime;
        } else {
          _selectedEndTime = pickedTime;
        }
      });
    }
  }
}
