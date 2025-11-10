import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import 'course_list_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Category'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              final categories = categoryProvider.categories;
              
              if (categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No categories available',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select a course category to explore:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final colors = [
                          Colors.blue,
                          Colors.orange,
                          Colors.purple,
                          Colors.red,
                          Colors.teal,
                          Colors.indigo,
                        ];
                        final color = colors[index % colors.length];
                        
                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseListScreen(
                                    category: category,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [color.shade100, color.shade200],
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getCategoryIcon(category.name),
                                      size: 48,
                                      color: color.shade700,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: color.shade800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      category.description,
                                      style: TextStyle(
                                        color: color.shade600,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'data science':
        return Icons.analytics;
      case 'mechanical':
        return Icons.engineering;
      case 'electrical':
        return Icons.electrical_services;
      case 'computer science':
        return Icons.computer;
      default:
        return Icons.book;
    }
  }
}