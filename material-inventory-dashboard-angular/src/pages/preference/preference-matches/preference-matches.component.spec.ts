import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PreferenceMatchesComponent } from './preference-matches.component';

describe('PreferenceMatchesComponent', () => {
  let component: PreferenceMatchesComponent;
  let fixture: ComponentFixture<PreferenceMatchesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PreferenceMatchesComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PreferenceMatchesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
