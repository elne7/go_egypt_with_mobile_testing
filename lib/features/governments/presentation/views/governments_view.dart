import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_egypt_with_firebase/features/governments/presentation/bloc/governments_bloc.dart';
import 'package:go_egypt_with_firebase/features/governments/presentation/bloc/governments_event.dart';
import 'package:go_egypt_with_firebase/features/governments/presentation/bloc/governments_state.dart';
import 'package:go_egypt_with_firebase/features/governments/presentation/views/widgets/government_card_item.dart';
import 'package:go_egypt_with_firebase/features/governments/presentation/views/widgets/shimmer_government_card_item.dart';
import 'package:go_egypt_with_firebase/generated/l10n.dart';

class GovernmentsView extends StatefulWidget {
  const GovernmentsView({super.key});

  @override
  State<GovernmentsView> createState() => _GovernmentsViewState();
}

class _GovernmentsViewState extends State<GovernmentsView> {
  @override
  void initState() {
    context.read<GovernmentsBloc>().add(LoadGovernments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          S.of(context).governments_of_egypt,
        ),
      ),
      body: BlocBuilder<GovernmentsBloc, GovernmentsState>(
        builder: (context, state) {
          if (state is GovernmentsLoading) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) =>
                  const ShimmerGovernmentCardItem(),
            );
          } else if (state is GovernmentsError) {
            return Center(child: Text(state.message));
          } else if (state is GovernmentsLoaded) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.governments.length,
              itemBuilder: (context, index) {
                final government = state.governments[index];
                return GovernmentCardItem(government: government);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
