import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PreferenceUploadFormComponent } from './preference-upload-form.component';

describe('PreferenceUploadFormComponent', () => {
  let component: PreferenceUploadFormComponent;
  let fixture: ComponentFixture<PreferenceUploadFormComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PreferenceUploadFormComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PreferenceUploadFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
