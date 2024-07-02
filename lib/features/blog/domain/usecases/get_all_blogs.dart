import 'package:authentication_blogs/core/error/failure.dart';
import 'package:authentication_blogs/core/usecase/usecase.dart';
import 'package:authentication_blogs/features/blog/domain/entities/blog.dart';
import 'package:authentication_blogs/features/blog/domain/reposetories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;

  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
