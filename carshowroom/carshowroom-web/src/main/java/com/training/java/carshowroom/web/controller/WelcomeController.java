package com.training.java.carshowroom.web.controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class WelcomeController {
	@RequestMapping("/login.html")
	public String login(){
		return "login";
	}

}
