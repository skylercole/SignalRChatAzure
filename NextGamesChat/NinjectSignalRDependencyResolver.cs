﻿using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNet.SignalR;
using Ninject;

namespace NextGamesChat
{
    // Ninject dependency resolver, courtesy of http://www.asp.net/signalr/overview/advanced/dependency-injection.
    internal class NinjectSignalRDependencyResolver : DefaultDependencyResolver
    {
        private readonly IKernel _kernel;
        public NinjectSignalRDependencyResolver(IKernel kernel)
        {
            _kernel = kernel;
        }

        public override object GetService(Type serviceType)
        {
            return _kernel.TryGet(serviceType) ?? base.GetService(serviceType);
        }

        public override IEnumerable<object> GetServices(Type serviceType)
        {
            return _kernel.GetAll(serviceType).Concat(base.GetServices(serviceType));
        }
    }
}