import 'package:flutter/material.dart';

void main() {
  runApp(const CollegeTrackerApp());
}

class CollegeTrackerApp extends StatelessWidget {
  const CollegeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CollegeSearchPage(),
    );
  }
}

class CollegeSearchPage extends StatefulWidget {
  const CollegeSearchPage({super.key});

  @override
  State<CollegeSearchPage> createState() => _CollegeSearchPageState();
}

class _CollegeSearchPageState extends State<CollegeSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<College> _filteredColleges = [];
  List<College> _allColleges = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadColleges();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadColleges() {
    _allColleges = [
      // Ivy League Universities
      College('Harvard University', 'Cambridge, MA', 'Ivy League', 'January 1', ['Harvard', 'HU', 'Harvard U'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (2)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$75)': true,
      }),
      College('Yale University', 'New Haven, CT', 'Ivy League', 'January 2', ['Yale', 'Yale U'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (2)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$80)': true,
      }),
      College('Princeton University', 'Princeton, NJ', 'Ivy League', 'January 1', ['Princeton', 'PU', 'Princeton U'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (2)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$70)': true,
      }),
      
      // Top Private Universities
      College('Stanford University', 'Stanford, CA', 'Private', 'January 2', ['Stanford', 'Stanford U'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (2)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$90)': true,
      }),
      College('Massachusetts Institute of Technology', 'Cambridge, MA', 'Private', 'January 1', ['MIT', 'MIT U'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (2)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$75)': true,
      }),
      
      // Major Public Universities
      College('University of California, Berkeley', 'Berkeley, CA', 'Public', 'November 30', ['UC Berkeley', 'Berkeley', 'Cal', 'UCB'], {
        'UC Application': true,
        'Official High School Transcript': true,
        'Personal Insight Questions': true,
        'SAT or ACT Scores': false, // Test-blind for CA residents
        'Application Fee (\$70)': true,
        'Teacher Recommendation': false,
        'Supplemental Essays': false,
      }),
      College('University of California, Los Angeles', 'Los Angeles, CA', 'Public', 'November 30', ['UCLA', 'UC Los Angeles'], {
        'UC Application': true,
        'Official High School Transcript': true,
        'Personal Insight Questions': true,
        'SAT or ACT Scores': false, // Test-blind for CA residents
        'Application Fee (\$70)': true,
        'Teacher Recommendation': false,
        'Supplemental Essays': false,
      }),
      College('University of Michigan', 'Ann Arbor, MI', 'Public', 'February 1', ['Michigan', 'UMich', 'U of M'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (1)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$75)': true,
      }),
      College('University of Virginia', 'Charlottesville, VA', 'Public', 'January 1', ['UVA', 'Virginia', 'U of Virginia'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (1)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$70)': true,
      }),
      
      // Test-Optional Colleges
      College('University of Chicago', 'Chicago, IL', 'Private', 'January 3', ['UChicago', 'Chicago U', 'UC'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (2)': true,
        'SAT or ACT Scores': false, // Test-optional
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$75)': true,
      }),
      College('Wake Forest University', 'Winston-Salem, NC', 'Private', 'January 1', ['Wake Forest', 'WFU', 'Wake'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (1)': true,
        'SAT or ACT Scores': false, // Test-optional
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$70)': true,
      }),
      
      // More colleges with accurate requirements...
      College('New York University', 'New York, NY', 'Private', 'January 1', ['NYU', 'New York U'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (1)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$80)': true,
      }),
      College('Boston University', 'Boston, MA', 'Private', 'January 4', ['BU', 'Boston U'], {
        'Common App or Coalition App': true,
        'Official High School Transcript': true,
        'School Report': true,
        'Teacher Recommendation (1)': true,
        'SAT or ACT Scores': true,
        'Personal Essay': true,
        'Supplemental Essays': true,
        'Application Fee (\$80)': true,
      }),
    ];
    _filteredColleges = List.from(_allColleges);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredColleges = List.from(_allColleges);
      } else {
        _filteredColleges = _allColleges.where((college) {
          // Search by full name
          if (college.name.toLowerCase().contains(query)) return true;
          
          // Search by location
          if (college.location.toLowerCase().contains(query)) return true;
          
          // Search by type
          if (college.type.toLowerCase().contains(query)) return true;
          
          // Search by abbreviations and nicknames
          for (String abbreviation in college.abbreviations) {
            if (abbreviation.toLowerCase().contains(query)) return true;
          }
          
          return false;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('College Tracker'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, abbreviation, or location...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          
          // Search Tips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 16, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Try: "MIT", "UCLA", "Harvard", "Penn", "GT", "Cal"',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  'Found ${_filteredColleges.length} colleges',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (_filteredColleges.isNotEmpty)
                  Text(
                    'Tap for details',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          
          // Colleges List
          Expanded(
            child: _filteredColleges.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No colleges found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredColleges.length,
                    itemBuilder: (context, index) {
                      final college = _filteredColleges[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Icon(
                              Icons.school,
                              color: Colors.blue[700],
                            ),
                          ),
                          title: Text(
                            college.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                college.location,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(college.type),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      college.type,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Deadline: ${college.deadline}',
                                    style: TextStyle(
                                      color: Colors.red[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                children: college.abbreviations.take(3).map((abbr) => 
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      abbr,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ).toList(),
                              ),
                            ],
                          ),
                          onTap: () {
                            _showCollegeDetails(college);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'ivy league':
        return Colors.purple;
      case 'private':
        return Colors.blue;
      case 'public':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showCollegeDetails(College college) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // College details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.school,
                            size: 30,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                college.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                college.location,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Type and Deadline
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Type',
                            college.type,
                            Icons.category,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            'Deadline',
                            college.deadline,
                            Icons.schedule,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Abbreviations section
                    const Text(
                      'Common Names & Abbreviations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: college.abbreviations.map((abbr) => 
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue[300]!),
                          ),
                          child: Text(
                            abbr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Requirements section
                    const Text(
                      'Application Requirements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...college.requirements.entries.map((entry) => 
                      _buildRequirementItem(entry.key, entry.value)
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Additional Info
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Early Decision Available', 'Yes'),
                    _buildInfoRow('Early Action Available', 'Yes'),
                    _buildInfoRow('Regular Decision', college.deadline),
                    _buildInfoRow('Financial Aid Deadline', 'February 1'),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String requirement, bool required) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            required ? Icons.check_circle : Icons.radio_button_unchecked,
            color: required ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              requirement,
              style: TextStyle(
                fontSize: 14,
                color: required ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class College {
  final String name;
  final String location;
  final String type;
  final String deadline;
  final List<String> abbreviations;
  final Map<String, bool> requirements;

  College(this.name, this.location, this.type, this.deadline, this.abbreviations, this.requirements);
}
