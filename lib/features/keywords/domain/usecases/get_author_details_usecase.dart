import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/author.dart';
import '../repositories/author_repository.dart';

@lazySingleton
class GetAuthorDetailsUseCase implements UseCase<Author, String> {
  final AuthorRepository _repository;

  GetAuthorDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, Author>> call(String params) {
    return _repository.getAuthorDetails(params);
  }
}
