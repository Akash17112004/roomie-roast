import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/fairness_provider.dart';
import '../../providers/duty_provider.dart';

class FairnessScreen
    extends StatelessWidget {
  const FairnessScreen(
      {super.key});

  @override
  Widget build(
      BuildContext context) {
    final fairness =
        Provider.of<
            FairnessProvider>(
      context,
    );

    final duty =
        Provider.of<
            DutyProvider>(
      context,
    );

    final board =
        fairness.leaderboard();

    final primary =
        const Color(0xff7b61ff);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fairness Engine",
        ),
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(
            colors: [
              Colors.deepPurple
                  .shade50,
              Colors.white,
              Colors.pink
                  .shade50,
            ],
            begin:
                Alignment.topLeft,
            end: Alignment
                .bottomRight,
          ),
        ),

        child: ListView(
          padding:
              const EdgeInsets
                  .all(16),

          children: [

            /// HEADER
            Container(
              padding:
                  const EdgeInsets
                      .all(20),
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

              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    "⚖️ Fairness Engine",
                    style:
                        TextStyle(
                      color: Colors
                          .white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                  SizedBox(
                      height: 8),
                  Text(
                    "Who carries the house and who hides from dishes 👀",
                    style:
                        TextStyle(
                      color: Colors
                          .white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                height: 20),

            /// LEADERBOARD TITLE
            const Text(
              "🏆 Contribution Leaderboard",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 12),

            ...board.asMap().entries.map(
              (entry) {
                final i =
                    entry.key;
                final e =
                    entry.value;

                final medals = [
                  "🥇",
                  "🥈",
                  "🥉"
                ];

                final badge =
                    i < 3
                        ? medals[i]
                        : "😴";

                return Container(
                  margin:
                      const EdgeInsets
                          .only(
                    bottom: 12,
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
                      radius:
                          26,
                      backgroundColor:
                          primary
                              .withOpacity(
                                  .12),
                      child:
                          Text(
                        badge,
                        style:
                            const TextStyle(
                          fontSize:
                              20,
                        ),
                      ),
                    ),

                    title: Text(
                      e["name"],
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
                                  6),
                      child: Text(
                        e["title"],
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
                        "${e["score"]}",
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color: Colors
                              .green,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(
                height: 24),

            /// DUTY TITLE
            const Text(
              "🧹 Weekly Duty Rotation",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 12),

            ...duty
                .assignments()
                .map(
                  (e) =>
                      Container(
                    margin:
                        const EdgeInsets
                            .only(
                      bottom: 12,
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
                        backgroundColor:
                            Colors.orange
                                .shade50,
                        child:
                            const Icon(
                          Icons
                              .cleaning_services,
                          color: Colors
                              .orange,
                        ),
                      ),

                      title: Text(
                        e["member"]!,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
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
                              .purple
                              .shade50,
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),
                        child:
                            Text(
                          e["duty"]!,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            color: Color(
                                0xff7b61ff),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

            const SizedBox(
                height: 10),

            ElevatedButton.icon(
              onPressed: () {
                duty.nextWeek();
              },
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                "Rotate Next Week",
              ),
              style:
                  ElevatedButton.styleFrom(
                minimumSize:
                    const Size(
                        double.infinity,
                        55),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          18),
                ),
              ),
            ),

            const SizedBox(
                height: 30),
          ],
        ),
      ),
    );
  }
}