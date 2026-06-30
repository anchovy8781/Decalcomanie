import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/loading_indicator.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nicknameController;
  late final TextEditingController _bioController;
  File? _selectedImage;
  bool _initialized = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _initControllers() {
    if (_initialized) return;
    final profile = ref.read(currentProfileProvider).valueOrNull;
    _nicknameController = TextEditingController(text: profile?.nickname ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _initialized = true;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    final notifier = ref.read(profileNotifierProvider.notifier);

    // Upload photo first if selected
    if (_selectedImage != null) {
      final photoResult = await notifier.uploadProfilePhoto(
        uid: user.uid,
        imageFile: _selectedImage!,
      );
      if (!mounted) return;
      if (photoResult.isFailure) {
        _showError(photoResult.errorOrNull!);
        return;
      }
    }

    final result = await notifier.updateProfile(
      uid: user.uid,
      nickname: _nicknameController.text.trim(),
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
    );

    if (!mounted) return;

    result.fold(
      onSuccess: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필이 저장되었습니다.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      },
      onFailure: _showError,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteAccount),
        content: const Text(AppStrings.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.deleteAccount),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final result = await ref.read(authNotifierProvider.notifier).deleteAccount();
      if (!mounted) return;
      result.fold(
        onSuccess: (_) => context.go('/login'),
        onFailure: _showError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initControllers();

    final profileAsync = ref.watch(currentProfileProvider);
    final isSaving = ref.watch(profileNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.close_rounded),
        ),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _save,
            child: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(AppStrings.save),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile photo — shows local file immediately after picking
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : null,
                        child: _selectedImage == null
                            ? ProfileAvatar(
                                photoUrl: profile?.photoUrl,
                                radius: 52,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.nickname,
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: Validators.nickname,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.bio,
                    hintText: '자신을 소개해보세요. (최대 150자)',
                    prefixIcon: Icon(Icons.edit_note_rounded),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  maxLength: 150,
                  validator: Validators.bio,
                ),
                const SizedBox(height: 40),

                // Danger zone
                const Divider(),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _showDeleteAccountDialog,
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: const Text(AppStrings.deleteAccount),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const AppLoadingIndicator(),
        error: (e, _) => const Center(child: Text('프로필을 불러올 수 없습니다.')),
      ),
    );
  }
}
