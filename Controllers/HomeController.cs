﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SimpleFrameworkApp.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        
                public ActionResult IndexCopy()
        {
            return View();
        }

        public ActionResult AboutCopy()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult ContactCopy()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        
            // GET: /HelloWorld/
    public string Index()
    {
        return "This is my default action...";
    }
    // 
    // GET: /HelloWorld/Welcome/ 
    public string Welcome()
    {
        return "This is the Welcome action method...";
    }
    }
}
