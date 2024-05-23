package backend.lezaczek.Repositories;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import backend.lezaczek.Model.User;


@Repository
public interface UsersRepository extends JpaRepository<User, Long>{
    @Query(value = "SELECT TOP (1) * FROM Users WHERE email = :#{#email}", nativeQuery = true)
    User findByEmail(@Param("email") String email);
}
