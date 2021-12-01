# Automapper

Oct 2017

> Framework for populating target object properties form source object properties useful for mapping between data transfer, domain and data pocos.

```
namespace Web.Models
{
    using System.Collections.Generic;

    public interface IMapper<TDto, TViewModel>
    {
        IList<TDto> ToDtoModel(IList<TViewModel> source);

        TDto ToDtoModel(TViewModel source);

        IList<TViewModel> ToViewModel(IList<TDto> source);

        TViewModel ToViewModel(TDto source);
    }
}
```

```
namespace Web.Models
{
    using System.Collections.Generic;
    using AutoMapper;

    public class WorkflowMapper<TDto, TViewModel> : IMapper<TDto, TViewModel>
    {
        private readonly IMapper mapper;

        public WorkflowMapper()
        {
            var config = new MapperConfiguration(c =>
            {
                c.CreateMap<Core.Models.Organisation, Web.Models.Organisation>()
                c.CreateMap<Web.Models.Organisation, Core.Models.Organisation>();
            });

            this.mapper = config.CreateMapper();
        }

        public TViewModel ToViewModel(TDto source)
        {
            var model = this.mapper.Map<TViewModel>(source);
            return model;
        }

        public IList<TViewModel> ToViewModel(IList<TDto> source)
        {
            var model = this.mapper.Map<IList<TViewModel>>(source);
            return model;
        }

        public TDto ToDtoModel(TViewModel source)
        {
            var model = this.mapper.Map<TDto>(source);
            return model;
        }

        public IList<TDto> ToDtoModel(IList<TViewModel> source)
        {
            var model = this.mapper.Map<IList<TDto>>(source);
            return model;
        }
    }
}
```