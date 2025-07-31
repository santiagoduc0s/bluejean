import 'package:flutter/material.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/alerts/dialog/dialog.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/domain/entities/entities.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/devices/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DevicesNotifier>().loadDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final notifier = context.watch<DevicesNotifier>();

    if (notifier.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    Widget body;
    if (notifier.devices.isEmpty) {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_other,
              size: 64,
              color: colors.onSurfaceVariant,
            ),
            2.spaceY,
            Text(
              l10n.noDevicesFound,
              style: textStyles.titleMedium.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: notifier.loadDevices,
        child: ListView.separated(
          padding: EdgeInsets.all(4.space),
          itemCount: notifier.devices.length,
          separatorBuilder: (_, __) => 2.spaceY,
          itemBuilder: (context, index) {
            final device = notifier.devices[index];
            final isCurrentDevice = notifier.currentDevice?.id == device.id;
            return _DeviceCard(
              device: device,
              isCurrentDevice: isCurrentDevice,
              onDelete: () =>
                  _showDeleteDeviceDialog(context, device, isCurrentDevice),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageDevices),
        backgroundColor: Colors.transparent,
      ),
      body: body,
    );
  }

  Future<void> _showDeleteDeviceDialog(
    BuildContext context,
    DeviceEntity device,
    bool isCurrentDevice,
  ) async {
    final l10n = context.l10n;
    final message = isCurrentDevice
        ? '${l10n.deleteDeviceConfirmation}\n\n'
            '${l10n.deleteCurrentDeviceWarning}'
        : l10n.deleteDeviceConfirmation;

    final result = await context.read<CustomDialog>().confirm(
          title: l10n.deleteDevice,
          message: message,
          confirmText: l10n.delete,
          cancelText: l10n.cancel,
        );

    if (result && context.mounted) {
      await context.read<DevicesNotifier>().deleteDevice(device.id);
    }
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.isCurrentDevice,
    required this.onDelete,
  });

  final DeviceEntity device;
  final bool isCurrentDevice;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Card(
      color: isCurrentDevice ? colors.primaryContainer : null,
      child: Padding(
        padding: EdgeInsets.all(4.space),
        child: Row(
          children: [
            Icon(
              Icons.phone_android,
              size: 32,
              color:
                  isCurrentDevice ? colors.onPrimaryContainer : colors.primary,
            ),
            3.spaceX,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          device.model.isNotEmpty
                              ? device.model
                              : 'Unknown Device',
                          style: textStyles.titleMedium.copyWith(
                            color: isCurrentDevice
                                ? colors.onPrimaryContainer
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  1.spaceY,
                  Text(
                    'Added: ${device.createdAt.day}/${device.createdAt.month}/${device.createdAt.year}',
                    style: textStyles.bodySmall.copyWith(
                      color: isCurrentDevice
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete,
                color: colors.error,
              ),
              tooltip: context.l10n.deleteDevice,
            ),
          ],
        ),
      ),
    );
  }
}
