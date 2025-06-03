
    using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Http;
using WebOptimizer;
    
namespace SimpleFrameworkApp
    {
        public class Program
        {
            public static void Main(string[] args)
            {
                var builder = WebApplication.CreateBuilder(args);
                
                // Store configuration in static ConfigurationManager
                ConfigurationManager.Configuration = builder.Configuration;
                
                // Add services to the container (formerly ConfigureServices)
                builder.Services.AddControllersWithViews();

                // Areas support
                builder.Services.AddRazorPages().AddRazorPagesOptions(options => {
                    options.RootDirectory = "/";
                });

                // MVC related services
                builder.Services.AddMvc(options => {
                    // Configure filters (equivalent to FilterConfig.RegisterGlobalFilters)
                });

                // Add client-side validation configuration from Web.config appSettings
                builder.Services.AddOptions();
                builder.Services.Configure<MvcViewOptions>(options => {
                    options.HtmlHelperOptions.ClientValidationEnabled = true;
                });

                // Add bundling services (equivalent to BundleConfig.RegisterBundles)
                builder.Services.AddWebOptimizer(pipeline =>
                {
                    // Configure your bundles here
                });

                // Configure Newtonsoft.Json (referenced in Web.config assemblyBinding)
                builder.Services.AddControllers().AddNewtonsoftJson();
                //Added Services
                
                var app = builder.Build();
                
                // Configure the HTTP request pipeline (formerly Configure method)
                if (app.Environment.IsDevelopment())
                {
                    app.UseDeveloperExceptionPage();
                }
                else
                {
                    app.UseExceptionHandler("/Home/Error");
                    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                    app.UseHsts();
                }
                
                app.UseHttpsRedirection();
                app.UseStaticFiles();
                
                //Added Middleware

                // Bundle middleware
                app.UseWebOptimizer();

                app.UseRouting();
                
                app.UseAuthorization();
                
                // Area registration
                app.MapControllerRoute(
                    name: "areas",
                    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

                // Default route (equivalent to RouteConfig.RegisterRoutes)
                app.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");

                // Enable Razor Pages
                app.MapRazorPages();
                
                app.Run();
            }
        }
        
        public class ConfigurationManager
        {
            public static IConfiguration Configuration { get; set; }
        }
    }