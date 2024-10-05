# Blazor cascade auth

Mar 2024

> Cascade domain user down component tree

Register cascading parameter 

Program.cs

```
builder.Services.AddCascadingAuthenticationState();

builder.Services.AddSingleton<IAssetUser>(sp => {
    var assetUser = new AssetUser();
    return assetUser;
});

builder.Services.AddSingleton<CascadingValueSource<IAssetUser>>(sp =>
{
    var assetUser = sp.GetRequiredService<IAssetUser>();
    return new CascadingValueSource<IAssetUser>(value: assetUser, isFixed: false);
});

builder.Services.AddCascadingValue(sp =>
{
    var source = sp.GetRequiredService<CascadingValueSource<IAssetUser>>();
    return source;
});
```

CascadingAssetUser.razor

```
@if (IsLoaded)
{ 
    @ChildContent
}
```

CascadingAssetUser.razor.cs
```
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.AspNetCore.Components.WebAssembly.Authentication;

namespace Nlist.Asset.UI.Client.Components
{
    public partial class CascadingAssetUser : IDisposable
    {
        [Inject]
        private ILogger<CascadingAssetUser> Logger { get; set; }

        [CascadingParameter]
        private IAssetUser AssetUser { get; set; }

        [Inject]
        private IAssetUserProvider AssetUserProvider { get; set; }

        [CascadingParameter]
        protected Task<AuthenticationState> AuthenticationState { get; set; }

        [Parameter]
        public RenderFragment ChildContent { get; set; }

        protected bool IsLoaded { get; set; }

        protected override async Task OnInitializedAsync()
        {
            this.NavigationManager.LocationChanged += LocationChanged;
        }

        protected override async Task OnParametersSetAsync()
        {
            var authenticationState = await AuthenticationState;
            var isAuthenticated = authenticationState.User?.Identity?.IsAuthenticated == true;

            if (isAuthenticated != this.AssetUser.Identity.IsAuthenticated)
            {
                await RefreshAssetUser();
            }

            IsLoaded = true;
        }

        private void LocationChanged(object? sender, LocationChangedEventArgs e)
        {
            base.InvokeAsync(async () => {

                await RefreshAssetUser();
                await AssetUserSource.NotifyChangedAsync(); 
            });
        }

        private async Task RefreshAssetUser()
        {
            try
            {
                var assetUser = await this.AssetUserProvider.GetAssetUserAsync();
                this.AssetUser!.Update(assetUser);
            }
            catch(AccessTokenNotAvailableException exception)
            {
                exception.Redirect();
            }  
        }

        void IDisposable.Dispose()
        {
            this.NavigationManager.LocationChanged -= LocationChanged;
        }
    }
}
```

Page.cs
```
public abstract class Page : ComponentBase
{
    [CascadingParameter]
    protected IAssetUser AssetUser { get; set; }
}
```

