# Using Angular Reactive Forms to Create Model Driven Forms

May 2019

> Using angular reactive forms to create model driven and dynamic forms improving test ability.

Reactive forms are model driven forms, they define controls, react to input values and events, validate input values and display new controls; defined in various classes.

## A Reactive Form is a FormGroup

```
import { Component, OnInit } from '@angular/core';
import { ContextService } from '../context.service';
import { FormGroup, FormControl, FormBuilder, AbstractControl, Validators } from '@angular/forms';
import { LocalValidator } from '../contains-validator';

@Component({
  selector: 'app-contact-form',
  templateUrl: './contact-form.component.html',
  styleUrls: ['./contact-form.component.less']
})
export class ContactFormComponent implements OnInit {

  public form: FormGroup;

  constructor(
    private contextService: ContextService,
    private fb: FormBuilder) { 

    this.submitted  = false;
  }
}
```

FormGroup contains many FormControls, Each form needs one root form group, a FormControl defines an input field.

```
createFormGroup() : FormGroup
{
    // Each form needs one form group.
    var formGroup = new FormGroup({
      name: 
        new FormControl(
          '',
          {
            validators: [
              Validators.required, 
              Validators.minLength(4), 
              Validators.maxLength(128)],
            updateOn: 'blur',
          }),
      email: 
        new FormControl(
          '',
          {
            validators: [
              Validators.required, 
              Validators.minLength(5), 
              Validators.maxLength(128), 
              Validators.pattern('(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])')],
            updateOn: 'blur',
          }),
      phone: 
        new FormControl(
          '',
          {
            validators: [
              Validators.minLength(11), 
              Validators.maxLength(17)],
            updateOn: 'blur',
          }),
      message: 
        new FormControl(
          '',
          {
            validators: [
              LocalValidator.ContainsValidator, 
              Validators.required, 
              Validators.minLength(16),
              Validators.maxLength(4096)],
            updateOn: 'blur',
          })
      });

    return formGroup;
}
```

FormControl is an input field.

```
new FormControl(
  'initial value',
  {
    validators: [
      LocalValidator.ContainsValidator, 
      Validators.required, 
      Validators.minLength(16),
      Validators.maxLength(4096)],
    updateOn: 'blur',
  });
```

## Improve code by using properties to wrap form control access

Create properties to clean access to FormControls, FormControl inherit AbstractControl.

```
get nameControl () : AbstractControl {
  return this.form.get('name');
}

get emailControl () : AbstractControl {
  return this.form.get('email');
}

get phoneControl () : AbstractControl {
  return this.form.get('phone');
}

get messageControl () : AbstractControl {
  return this.form.get('message');
}
```

Create additional properties for each FormControl providing view with state information.

```
get nameControl () : AbstractControl {
  return this.form.get('name');
}

get nameControlIsValid(): boolean {
  if (this.submitted)
  {
    return (this.nameControl.invalid);
  }
  return (this.nameControl.invalid) && (this.nameControl.dirty || this.nameControl.touched);
}

get nameControlName() : string {
  return 'Name';
}

public nameControlValidationMessages : Map<string, string>;

public nameControlSubscribeValueChanges() {
}

public nameControlSubscribeStatusChanges() {
}
```

### Subscribe to value changes

### Subscribe status changes

## Bind component properties to view
```
<form (ngSubmit)="Save()" [formGroup]="form">
  <div class="form-group row">
    <label for="name" class="col-sm-3 col-form-label">Name</label>
    <div class="col-sm-9">
      <input type="text" formControlName="name" class="form-control" id="name" placeholder="Name"
        [ngClass]="{'is-invalid':nameControlIsValid}" />

      <div *ngIf="nameControlIsValid" class="alert alert-danger">
        <div *ngIf="nameControl.errors?.required">
          {{nameControlName}} is required.
        </div>
        <div *ngIf="nameControl.errors?.minlength">
          Looks like {{nameControlName}} is to short, over 4 characters is good.
        </div>
        <div *ngIf="nameControl.errors?.maxlength">
          Looks like {{nameControlName}} is to long, under 128 characters is good.
        </div>
      </div>
    </div>
  </div>
</form>
```

Create a class to wrap FormControl properties.

```
import { AbstractControl } from '@angular/forms';

export class FormItem {

  constructor(
    private formControl: AbstractControl,
    private formControlName: string) { 
  } 

  get control () : AbstractControl {
    return this.formControl;
  }

  get isValid(): boolean {
    return (this.formControl.invalid) && (this.formControl.dirty || this.formControl.touched);
  }

  get name() : string {
    return this.formControlName;
  }

  public validationMessages : Map<string, string>;

  public subscribeValueChanges() {
  }

  public subscribeStatusChanges() {
  }
}
```