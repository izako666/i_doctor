import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:i_doctor/UI/app_theme.dart';
import 'package:i_doctor/UI/util/i_app_bar.dart';
import 'package:i_doctor/api/data_classes/user.dart';
import 'package:i_doctor/fake_data.dart';
import 'package:i_doctor/portable_api/helper.dart';
import 'package:readmore/readmore.dart';

class ReviewView extends StatefulWidget {
  const ReviewView(
      {super.key,
      required this.reviews,
      required this.type,
      this.tabExists = true});
  final List<Review> reviews;
  final String type;
  final bool tabExists;

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  bool opened = false;
  bool isClinic = false;
  @override
  void initState() {
    super.initState();
    isClinic = widget.type == 'clinic';
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
        itemCount: widget.reviews.length + 1,
        itemBuilder: (ctx, i) {
          if (widget.tabExists && i == 0) {
            return Material(
              elevation: 1,
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  opened = !opened;
                  setState(() {});
                },
                child: Container(
                  width: getScreenWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: const Border(
                          bottom: BorderSide(color: Colors.black))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        opened
                            ? Icons.arrow_drop_up_rounded
                            : Icons.arrow_drop_down_rounded,
                        color: Colors.transparent,
                      ),
                      Text(t(context).reviews2(widget.reviews.length)),
                      Icon(
                        opened
                            ? Icons.arrow_drop_up_rounded
                            : Icons.arrow_drop_down_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if ((opened || !widget.tabExists) && i != 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                width: getScreenWidth(ctx),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [secondaryColor, backgroundColor],
                        stops: [0.0, 0.7]),
                    border: const Border(bottom: BorderSide())),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.reviews[i - 1].user.custArbName),
                          Text(
                              '${formatDate(widget.reviews[i - 1].date)}  ${formatTime(widget.reviews[i - 1].date)}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBarIndicator(
                            itemSize: 16,
                            itemBuilder: (ctx, i) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            rating: widget.reviews[i - 1].rating,
                          ),
                          if (isClinic)
                            Text(
                              widget.reviews[i - 1].productName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: secondaryColor),
                            )
                        ],
                      ),
                      Divider(
                        indent: 0,
                        endIndent: getScreenWidth(ctx) * 0.6,
                      ),
                      const SizedBox(height: 4),
                      ReadMoreText(
                        textAlign: TextAlign.start,
                        widget.reviews[i - 1].review,
                        trimMode: TrimMode.Length,
                        trimLength: 100,
                        trimCollapsedText: t(context).readMore,
                        trimExpandedText: t(context).displayLess,
                        colorClickableText: secondaryFgColor,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        });
  }
}

class Review {
  final User user;
  final String review;
  final double rating;
  final DateTime date;
  final String? productId;
  final String? productName;
  Review(
      {required this.user,
      required this.review,
      required this.rating,
      required this.date,
      this.productId,
      this.productName});
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.type,
    required this.id,
  });
  //either a product review or clinic review
  final String type;
  //later on we will use this to find the reviews
  final String id;
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isClinic = false;

  @override
  void initState() {
    super.initState();
    isClinic = widget.type == 'clinic';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBar(
        title: t(context).reviews2(12),
        hasBackButton: true,
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: getScreenWidth(ctx),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: backgroundColor,
                  gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [secondaryColor, backgroundColor],
                      stops: [0.0, 0.7]),
                  border: const Border(bottom: BorderSide())),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(reviews[i].user.custArbName),
                        Text(
                            '${formatDate(reviews[i].date)}  ${formatTime(reviews[i].date)}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBarIndicator(
                          itemSize: 16,
                          itemBuilder: (ctx, i) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          rating: reviews[i].rating,
                        ),
                        if (isClinic)
                          Text(
                            reviews[i].productName ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: secondaryColor),
                          )
                      ],
                    ),
                    Divider(
                      indent: 0,
                      endIndent: getScreenWidth(ctx) * 0.6,
                    ),
                    const SizedBox(height: 4),
                    ReadMoreText(
                      colorClickableText: secondaryFgColor,
                      textAlign: TextAlign.start,
                      reviews[i].review,
                      trimMode: TrimMode.Length,
                      trimLength: 100,
                      trimCollapsedText: t(context).readMore,
                      trimExpandedText: t(context).displayLess,
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: reviews.length,
      ),
    );
  }
}
