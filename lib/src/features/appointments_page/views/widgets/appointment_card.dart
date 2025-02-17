import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../core/shared/shared.dart';
import '../../../../utils/string_extension.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../payment_page/models/appointment_model.dart';
import '../../../payment_page/models/payment_model.dart';
import '../../../service_details_page/views/service_details_page.dart';
import '../../providers/provider.dart';
import '../../providers/state.dart';

class AppointmentCard extends ConsumerWidget {
  final AppointmentModel appointment;

  const AppointmentCard({super.key, required this.appointment});

  bool get isPaymentCompleted =>
      !isENTREPRENEUR &&
      appointment.status == AppointmentStatus.INITIATED &&
      appointment.payment?.status == PaymentStatus.PENDING;

  bool get isAppointmentCompleted => appointment.status == AppointmentStatus.COMPLETED;
  bool get showMarkAsCompleted => appointment.status == AppointmentStatus.BOOKED;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          ServiceDetailsPage.route,
          extra: ServiceDetailsParam(
            serviceID: appointment.serviceId,
            showActions: false,
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 150.px),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F8FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: KColors.black10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    appointment.service?.title ?? '',
                    maxLines: 2,
                    fontSize: 16,
                    color: KColors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: appointment.status.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AppText(
                    appointment.status == AppointmentStatus.INITIATED ? "Payment Pending" : appointment.status.name,
                    fontSize: 12,
                    maxLines: 1,
                    fontWeight: FontWeight.w500,
                    color: KColors.white,
                  ),
                ),
              ],
            ),
            const Divider(),
            const AppText(
              "Date & Time",
              fontSize: 12,
              color: KColors.black40,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.calendar,
                  size: 16,
                  color: KColors.purple,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    appointment.appointmentDate?.toDate("dd MMM, yyyy") ?? "",
                    maxLines: 1,
                    color: KColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.time,
                  size: 16,
                  color: KColors.purple,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    '${"2006-10-25T${appointment.startTime}".toDate("hh:mm a")} - ${"2006-10-25T${appointment.endTime}".toDate("hh:mm a")}',
                    maxLines: 1,
                    color: KColors.black,
                  ),
                ),
              ],
            ),
            if (appointment.homeServiceNeeded) ...[
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.home,
                    size: 16,
                    color: KColors.purple,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFFC83306),
                      ),
                      child: const AppText(
                        'Home service needed',
                        maxLines: 1,
                        color: KColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (isENTREPRENEUR) ...[
              const Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppText(
                          "Candidate details",
                          fontSize: 12,
                          color: KColors.black40,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: AppText(
                                appointment.candidate?.name ?? "",
                                maxLines: 1,
                                color: KColors.black,
                              ),
                            ),
                            if ((appointment.candidate?.email ?? "").isNotEmpty) ...[
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () => appointment.candidate?.email?.openEmail(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: KColors.purple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.mail,
                                    color: KColors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () => appointment.candidate?.phone?.callToPhone(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: KColors.purple,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.phone,
                                  color: KColors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (isPaymentCompleted) ...[
              const SizedBox(height: 10),
              AppButton(
                onTap: () => ref.read(appointmentsProvider.notifier).completePayment(context, appointment.payment!),
                text: "Complete payment",
              )
            ] else if (isENTREPRENEUR && !isAppointmentCompleted && showMarkAsCompleted) ...[
              const SizedBox(height: 10),
              AppButton(
                onTap: () => ref.read(appointmentsProvider.notifier).markAsCompleted(context, appointment.id!),
                elevation: 0,
                text: "Mark as completed",
                backgroundColor: KColors.yellow800,
              )
            ],
          ],
        ),
      ),
    );
  }
}
