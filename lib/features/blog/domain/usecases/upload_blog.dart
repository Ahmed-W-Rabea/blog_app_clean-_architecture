import 'dart:io';

import 'package:authentication_blogs/core/error/failure.dart';
import 'package:authentication_blogs/core/usecase/usecase.dart';
import 'package:authentication_blogs/features/blog/domain/entities/blog.dart';
import 'package:authentication_blogs/features/blog/domain/reposetories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogPArams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogPArams params) async {
    return await blogRepository.uploadBlog(
        image: params.image,
        title: params.title,
        content: params.content,
        posterId: params.posterId,
        topics: params.topics);
  }
}

class UploadBlogPArams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogPArams(
      {required this.posterId,
      required this.title,
      required this.content,
      required this.image,
      required this.topics});
}
