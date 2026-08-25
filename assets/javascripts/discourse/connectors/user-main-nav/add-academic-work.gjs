/** @ts-check */
import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import DButton from "discourse/components/d-button";
import AcademicSubmissionModal from "../components/modal/academic-submission-modal";
import { connectOutlet } from "discourse/lib/connectors"; // 1. Eklendi

export default connectOutlet("user-main-nav", class AddAcademicWorkConnector extends Component { // 2. Outlet adı bağlandı
  @service modal;
  @service currentUser;

  get shouldShow() {
    return this.currentUser && this.currentUser.id === this.args.outletArgs.user.id;
  }

  @action
  openSubmissionModal() {
    this.modal.show(AcademicSubmissionModal);
  }
});

<template>
  {{#if this.shouldShow}}
    <li class="add-academic-work-btn">
      <DButton
        @icon="book"
        @label="js.academic_repository.button.add_publication"
        @action={{this.openSubmissionModal}}
        class="btn-primary"
      />
    </li>
  {{/if}}
</template>