import 'package:app_1/models/donationModel.dart';
import 'package:flutter/material.dart';

class DonationDetail extends StatefulWidget {
  final Campaign campaign;

  DonationDetail({Key? key, required this.campaign}) : super(key: key);

  @override
  State<DonationDetail> createState() => _DonationDetailState();
}

class _DonationDetailState extends State<DonationDetail> {
 
  @override
  Widget build(BuildContext context) {
     String CampaignName = widget.campaign.CampaignName.toString();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: NetworkImage(
                            'https://img.rawpixel.com/s3fs-private/rawpixel_images/website_content/s93-pm-2757_1.jpg?w=800&dpr=1&fit=default&crop=default&q=65&vib=3&con=3&usm=15&bg=F4F4F3&ixlib=js-2.2.1&s=ca65807ad0c7f52233e70f1844204be5'),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(35)),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    IntrinsicHeight(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        VerticalDivider(
                            color: Colors.black, width: 50, thickness: 4),
                        Text(
                          CampaignName,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
               Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('${widget.campaign.CampaignDetail.toString()}',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Event date:',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 7),
                              Text(
                                '${widget.campaign.CampaignDate.toString()}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.grey,
                            width: 30,
                            thickness: 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Event venue:',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 7),
                              Text(
                                '${widget.campaign.CampaignVenue.toString()}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.grey,
                            width: 30,
                            thickness: 2,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Contact \ninformation:',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 7),
                              Text(
                                '${widget.campaign.ContactInformation}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
