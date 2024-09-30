import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PreferenceMatchesComponent } from './preference-matches.component';
import { PreferenceUploadFormComponent } from '../components/preference-upload-form/preference-upload-form.component';
import { PreferenceMatchTableComponent } from '../../../components/preference-match-table/preference-match-table.component';
import { CommonModule } from '@angular/common';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';

describe('PreferenceMatchesComponent', () => {
  let component: PreferenceMatchesComponent;
  let fixture: ComponentFixture<PreferenceMatchesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        PreferenceMatchesComponent,
        PreferenceUploadFormComponent,
        PreferenceMatchTableComponent,
        CommonModule,
      ],
      providers: [provideHttpClient(), provideHttpClientTesting()],
    }).compileComponents();

    fixture = TestBed.createComponent(PreferenceMatchesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
