abstract class Mapper<A, B> {
  const Mapper();

  B fromEntity(A entity);

  A toEntity(B item);
}
