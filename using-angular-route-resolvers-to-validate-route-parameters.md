# Using Angular Route Resolvers to Validate Route Parameters

May 2019

> Use Angular route resolvers to preload and validate data exist, redirect to not found or unauthorised.

Reducing access control logic in components improves maintainability, one strategy is to use Resolvers. 

## Resolver

```
import { Injectable } from '@angular/core';
import { Router, Resolve, RouterStateSnapshot, ActivatedRouteSnapshot } from '@angular/router';
import { Observable } from 'rxjs';
import { ContextService }  from './context.service';
import { CaseStudyOverview } from './case-study-overview';
 
@Injectable({
  providedIn: 'root',
})
export class CaseStudyOverviewResolverService implements Resolve<CaseStudyOverview> {
  constructor(private contextService: ContextService, private router: Router) {}
 
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<CaseStudyOverview> | Observable<never> {

    let path = route.url.map(i => i.path).join('/');

    return this.contextService.getCaseStudyOverview(path);
  }
}
```

## AppRoutingModule

```
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { HomeResolverService } from './home-resolver.service';
import { CaseStudyComponent } from './case-study/case-study.component';
import { CaseStudyResolverService } from './case-study-resolver.service'
import { PageComponent } from './page/page.component';
import { PageResolverService } from './page-resolver.service';

const routes: Routes = [
  { 
    path: '', 
    component: HomeComponent,
    resolve:{         
      model:HomeResolverService
    } 
  },
  { 
    path: 'case-studies', 
    component: CaseStudyOverviewComponent,
    resolve:{         
      model:CaseStudyOverviewResolverService
    } 
  },
  { 
    path: 'case-studies/:id', 
    component: CaseStudyComponent,
    resolve:{         
      model:CaseStudyResolverService
    } 
  },
  { 
    path: '**', 
    component: PageComponent,
    resolve:{         
      model:PageResolverService
    } 
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
```

## Access Preloaded Data

Access preloaded data 

```
import { Component, OnInit } from '@angular/core';
import { CaseStudyOverview } from '../case-study-overview';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-case-study-overview',
  templateUrl: './case-study-overview.component.html',
  styleUrls: ['./case-study-overview.component.less']
})
export class CaseStudyOverviewComponent implements OnInit {

  public model: CaseStudyOverview;

  constructor(
    private route: ActivatedRoute) { }

  ngOnInit() {
    this.model = this.route.snapshot.data["model"]; 
  }

}
```