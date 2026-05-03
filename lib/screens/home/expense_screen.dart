import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() =>
      _ExpenseScreenState();
}

class _ExpenseScreenState
    extends State<ExpenseScreen> {
  final titleController =
      TextEditingController();

  final amountController =
      TextEditingController();

  final paidByController =
      TextEditingController();

  final primary =
      const Color(0xff7b61ff);

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    paidByController.dispose();
    super.dispose();
  }

  void showAddExpenseDialog(
    ExpenseProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  24),
        ),
        title: const Text(
          "💸 Add Expense",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  titleController,
              decoration:
                  const InputDecoration(
                hintText:
                    "Expense title",
                prefixIcon:
                    Icon(Icons.notes),
              ),
            ),

            const SizedBox(
                height: 12),

            TextField(
              controller:
                  amountController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                hintText: "Amount",
                prefixIcon:
                    Icon(Icons.currency_rupee),
              ),
            ),

            const SizedBox(
                height: 12),

            TextField(
              controller:
                  paidByController,
              decoration:
                  const InputDecoration(
                hintText: "Paid by",
                prefixIcon:
                    Icon(Icons.person),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context),
            child:
                const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {
              final title =
                  titleController
                      .text
                      .trim();

              final paidBy =
                  paidByController
                      .text
                      .trim();

              final amount =
                  double.tryParse(
                        amountController
                            .text
                            .trim(),
                      ) ??
                      0;

              if (title
                      .isEmpty ||
                  paidBy
                      .isEmpty ||
                  amount <= 0) {
                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Enter valid details",
                    ),
                  ),
                );
                return;
              }

              await provider
                  .addExpense(
                title: title,
                amount: amount,
                paidBy: paidBy,
              );

              titleController
                  .clear();
              amountController
                  .clear();
              paidByController
                  .clear();

              if (mounted) {
                Navigator.pop(
                    context);
              }
            },
            child:
                const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ExpenseProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Splitter",
        ),
        centerTitle: true,
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () =>
            showAddExpenseDialog(
          provider,
        ),
        icon:
            const Icon(Icons.add),
        label:
            const Text("Add"),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple
                  .shade50,
              Colors.white,
              Colors.pink.shade50,
            ],
            begin:
                Alignment.topLeft,
            end: Alignment
                .bottomRight,
          ),
        ),

        child: StreamBuilder<
            QuerySnapshot>(
          stream:
              provider.getExpenses(),
          builder:
              (_, snapshot) {
            if (!snapshot
                .hasData) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            final docs =
                snapshot
                    .data!
                    .docs;

            double total = 0;

            for (var doc
                in docs) {
              final data =
                  doc.data()
                      as Map<String,
                          dynamic>;

              total +=
                  ((data["amount"] ??
                              0)
                          as num)
                      .toDouble();
            }

            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  "No expenses yet 💸",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),
              );
            }

            return Column(
              children: [

                /// TOP SUMMARY CARD
                Container(
                  width:
                      double.infinity,
                  margin:
                      const EdgeInsets
                          .all(16),
                  padding:
                      const EdgeInsets
                          .all(18),
                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(
                            0xff7b61ff),
                        Color(
                            0xff9f7bff),
                      ],
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                                24),
                    boxShadow: [
                      BoxShadow(
                        color: primary
                            .withOpacity(
                                .25),
                        blurRadius:
                            14,
                        offset:
                            const Offset(
                                0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        "💰 Shared Wallet",
                        style:
                            TextStyle(
                          color: Colors
                              .white,
                          fontSize:
                              22,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      const SizedBox(
                          height: 8),
                      Text(
                        "Total Spend ₹${total.toStringAsFixed(0)}",
                        style:
                            const TextStyle(
                          color: Colors
                              .white70,
                          fontSize:
                              16,
                        ),
                      ),
                    ],
                  ),
                ),

                /// EXPENSE LIST
                Expanded(
                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets
                            .only(
                      left: 14,
                      right: 14,
                      bottom: 90,
                    ),
                    itemCount:
                        docs.length,
                    itemBuilder:
                        (_, i) {
                      final data =
                          docs[i].data()
                              as Map<String,
                                  dynamic>;

                      final title =
                          data["title"] ??
                              "Untitled";

                      final paidBy =
                          data["paidBy"] ??
                              "Unknown";

                      final amount =
                          ((data["amount"] ??
                                      0)
                                  as num)
                              .toDouble();

                      final split =
                          ((data["splitAmount"] ??
                                      0)
                                  as num)
                              .toDouble();

                      final members =
                          data["members"] ??
                              1;

                      return Container(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom: 14,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors
                              .white,
                          borderRadius:
                              BorderRadius.circular(
                                  22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                      .05),
                              blurRadius:
                                  10,
                              offset:
                                  const Offset(
                                      0, 6),
                            ),
                          ],
                        ),
                        child:
                            ListTile(
                          contentPadding:
                              const EdgeInsets
                                  .all(
                                      16),

                          leading:
                              CircleAvatar(
                            radius: 26,
                            backgroundColor:
                                primary
                                    .withOpacity(
                                        .12),
                            child:
                                const Icon(
                              Icons
                                  .currency_rupee,
                              color:
                                  Color(
                                      0xff7b61ff),
                            ),
                          ),

                          title:
                              Text(
                            title,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontSize:
                                  17,
                            ),
                          ),

                          subtitle:
                              Padding(
                            padding:
                                const EdgeInsets.only(
                                    top:
                                        8),
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  "Paid by $paidBy",
                                ),
                                const SizedBox(
                                    height:
                                        4),
                                Text(
                                  "Split ₹${split.toStringAsFixed(0)} each",
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        4),
                                Text(
                                  provider
                                      .whoOwesWhom(
                                    paidBy,
                                    split,
                                    members,
                                  ),
                                  style:
                                      TextStyle(
                                    color: Colors
                                        .grey
                                        .shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          trailing:
                              Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  12,
                              vertical:
                                  8,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .green
                                  .shade50,
                              borderRadius:
                                  BorderRadius.circular(
                                      14),
                            ),
                            child:
                                Text(
                              "₹${amount.toStringAsFixed(0)}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Colors.green,
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
    );
  }
}