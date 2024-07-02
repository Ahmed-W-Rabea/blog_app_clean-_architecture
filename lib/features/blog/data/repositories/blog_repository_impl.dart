// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:authentication_blogs/core/constants/constants.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import 'package:authentication_blogs/core/error/exceptions.dart';
import 'package:authentication_blogs/core/error/failure.dart';
import 'package:authentication_blogs/core/network/connection_checker.dart';
import 'package:authentication_blogs/features/blog/data/datasources/blog_loca_data_source.dart';
import 'package:authentication_blogs/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:authentication_blogs/features/blog/data/models/blog_model.dart';
import 'package:authentication_blogs/features/blog/domain/entities/blog.dart';
import 'package:authentication_blogs/features/blog/domain/reposetories/blog_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(message: Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = await BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final blogs = await blogRemoteDataSource.getAllBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
