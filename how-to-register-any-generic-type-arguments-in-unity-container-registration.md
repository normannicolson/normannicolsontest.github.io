# How to Register any Generic Type Arguments in Unity Container Registration

Oct 2017

> Reduce the number of container registrations by using generic types.

container.RegisterType(typeof(Mappers.IMapper<,>), typeof(Mappers.Mapper<,>));