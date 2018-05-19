package top.whysu.front.service;


import top.whysu.manager.dto.front.Member;

public interface LoginService {

    Member userLogin(String username, String password);

    Member getUserByToken(String token);

    int logout(String token);
}
