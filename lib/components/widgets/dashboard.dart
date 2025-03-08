import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification action here
            },
          ),
        ],
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 25.0), // Push logo down
          child: Center(
            child: Image.asset(
              'assets/images/logo_without_name_white.png', // Your logo path
              height: 80, // Make logo bigger by increasing the height
            ),
          ),
        ),
        elevation: 0, // Optional: Remove the elevation (shadow)
        backgroundColor: Colors.blue, // AppBar background color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white,
          ),
          width: screenWidth * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildGreetingAndCards(context, screenHeight)],
          ),
        ),
      ),
    );
  }

  // Greeting and Cards Section
  Widget _buildGreetingAndCards(BuildContext context, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(left: 16.0)),
          SizedBox(height: screenHeight * 0.1),
          _buildClickableCard(context, 'View Prescriptions'),
          SizedBox(height: 28.0),
          _buildClickableCard(context, 'Log Intake'),
          SizedBox(height: 18.0),
          _buildClickableCard(context, 'View Refill Dates'),
        ],
      ),
    );
  }

  // Clickable Card Widget
  Widget _buildClickableCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
        if (title == 'View Prescriptions') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewPrescriptionsPage()),
          );
        } else if (title == 'Log Intake') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogIntakePage()),
          );
        } else if (title == 'View Refill Dates') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RefillDatesPage()),
          );
        }
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFCF8E8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 18.0,
              fontWeight: FontWeight.normal, // Unbold the text
            ),
            textAlign: TextAlign.center, // Center the text
          ),
        ),
      ),
    );
  }
}

// View Prescriptions Page
class ViewPrescriptionsPage extends StatelessWidget {
  const ViewPrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Prescriptions')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10, // Replace with dynamic data from your DB
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4.0,
              child: ListTile(
                title: Text('Medication Name #$index'),
                subtitle: Text('Prescription details...'),
                onTap: () {
                  // Handle item tap
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Log Intake Page
class LogIntakePage extends StatelessWidget {
  const LogIntakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log Medication Intake')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Log your medication intake here...'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle logging of intake
              },
              child: Text('Log Intake'),
            ),
          ],
        ),
      ),
    );
  }
}

// Refill Dates Page
class RefillDatesPage extends StatelessWidget {
  const RefillDatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Refill Dates')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10, // Replace with dynamic data from your DB
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4.0,
              child: ListTile(
                title: Text('Medication Name #$index'),
                subtitle: Text('Refill Date: 2025-03-07'),
                onTap: () {
                  // Handle item tap
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
