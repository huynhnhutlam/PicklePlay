import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListLoading extends StatelessWidget {
  final int itemCount;
  final double? itemHeight;
  final EdgeInsetsGeometry? padding;

  const ListLoading({
    super.key,
    this.itemCount = 8,
    this.itemHeight,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            height: itemHeight ?? 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(
                          3,
                          (i) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: 40,
                              height: 12,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
