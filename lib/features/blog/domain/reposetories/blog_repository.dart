import 'dart:io';

import 'package:authentication_blogs/core/error/failure.dart';
import 'package:authentication_blogs/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });
  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
