import 'package:coffee/controller/ordersController.dart';
import 'package:coffee/model/statusModel.dart';
import 'package:coffee/widgets/status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with AutomaticKeepAliveClientMixin {
  final DonationController donationController = Get.put(DonationController());
  final store = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    final userID = store.read('userID');
    if (userID == null || userID.toString().isEmpty) return;

    // Load cached donations if available
    final cachedData = store.read('cachedDonations');
    if (cachedData != null) {
      final List<dynamic> list = cachedData;
      donationController.userDonations.value =
          list.map((e) => Donation.fromJson(e)).toList();
      donationController.openingStatus
          .assignAll(List.filled(donationController.userDonations.length, false));
    }

    // Fetch fresh donations in the background
    await donationController.fetchPersonalDonations(userID.toString());

    // Cache fresh data
    store.write(
      'cachedDonations',
      donationController.userDonations.map((d) => d.toJson()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Status'),
        backgroundColor: Colors.brown,
      ),
      body: Obx(() {
        if (donationController.isLoadingUserDonations.value &&
            donationController.userDonations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (donationController.userDonations.isEmpty) {
          return const Center(child: Text("No orders found."));
        }

        return ListView.builder(
          itemCount: donationController.userDonations.length,
          itemBuilder: (context, index) {
            final donation = donationController.userDonations[index];
            final showFull = donationController.openingStatus.length > index
                ? donationController.openingStatus[index]
                : false;

            return StatusCard(
              donationId: donation.orderID,
              currentStatus: donation.status,
              itemName: donation.name,
              quantity: donation.quantity,
              price: donation.price,
              formattedDate: donation.formattedDate,
              showFullDetails: showFull,
              onToggleDetails: () {
                donationController.setOpeningStatus(index, !showFull);
              },
            );
          },
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
