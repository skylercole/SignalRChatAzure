using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using Microsoft.AspNet.SignalR.Infrastructure;
using Microsoft.Owin;
using Ninject;
using Owin;
[assembly: OwinStartup(typeof(NextGamesChat.Startup))]

namespace NextGamesChat
{
    public class Startup
    {
        // Any connection or hub wire up and configuration should go here
        public void Configuration(IAppBuilder app)
        {
            var kernel = new StandardKernel();
            var resolver = new NinjectSignalRDependencyResolver(kernel);

            kernel.Bind<IChatRepository>()
                .To<CloudStorage>()  // Bind to CloudStorage.
                .InSingletonScope();  // Make it a singleton object.

            kernel.Bind(typeof(IHubConnectionContext<dynamic>)).ToMethod(context =>
                    resolver.Resolve<IConnectionManager>().GetHubContext<ChatHub>().Clients
                        ).WhenInjectedInto<IChatRepository>();

            var config = new HubConfiguration {Resolver = resolver};
            ConfigureSignalR(app, config);
        }

        public static void ConfigureSignalR(IAppBuilder app, HubConfiguration config)
        {
            app.MapSignalR(config);
        }
    }
}