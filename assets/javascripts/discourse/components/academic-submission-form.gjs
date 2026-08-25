/** @ts-check */
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import Form from "discourse/components/form";
import DButton from "discourse/components/d-button";
import I18n from "discourse-i18n";

export default class AcademicSubmissionForm extends Component {
  @tracked workType = "journal_article";
  @tracked isResolvingDoi = false;
  @tracked doiInput = "";

  // Dinamik geçici veri (FormKit transient data)
  @tracked formData = {
    title: "",
    abstract: "",
    doi: "",
    isbn: "",
    venue_name: ""
  };

  get workTypeOptions() {
    return [
      { id: "journal_article", name: I18n.t("js.academic_repository.types.journal_article") },
      { id: "book", name: I18n.t("js.academic_repository.types.book") },
      { id: "thesis", name: I18n.t("js.academic_repository.types.thesis") }
    ];
  }

  @action
  async autofillFromDoi() {
    if (!this.doiInput) return;
    
    this.isResolvingDoi = true;
    try {
      const response = await ajax(`/academic/resolve/doi`, {
        type: "GET",
        data: { doi: this.doiInput }
      });
      
      // API'den gelen veriyi forma bas (Reactivity @tracked sayesinde otomatik günceller)
      this.formData = {
        ...this.formData,
        title: response.title || "",
        abstract: response.abstract || "",
        venue_name: response.venue_name || "",
        doi: this.doiInput
      };
    } catch (e) {
      // discourse-chat-integration hata formatında popup
      const { popupAjaxError } = require("discourse/lib/ajax-error");
      popupAjaxError(e);
    } finally {
      this.isResolvingDoi = false;
    }
  }

  @action
  async saveWork(data) {
    // FormKit validasyonları sonrası tetiklenir
    await ajax("/academic/works", {
      type: "POST",
      data: { academic_work: { ...this.formData, work_type: this.workType } }
    });
    // Başarı toast mesajı veya yönlendirme eklenecek
  }

  <template>
    <div class="academic-submission-container">
      <h3>{{I18n.t "js.academic_repository.form.title"}}</h3>
      
      {{!-- DOI Autofill Toolbar --}}
      <div class="academic-toolbar">
        <label>{{I18n.t "js.academic_repository.form.autofill_doi"}}</label>
        <input 
          type="text" 
          placeholder="10.1000/xyz123" 
          value={{this.doiInput}} 
          {{on "input" (action (mut this.doiInput) value="target.value")}}
        />
        <DButton 
          @action={{this.autofillFromDoi}} 
          @isLoading={{this.isResolvingDoi}}
          @icon="search"
          @label="js.academic_repository.form.autofill_btn"
        />
      </div>

      <hr/>

      {{!-- FormKit Kullanımı --}}
      <Form @onSubmit={{this.saveWork}} @data={{this.formData}} as |f|>
        
        <f.SelectKit 
          @name="work_type" 
          @content={{this.workTypeOptions}}
          @value={{this.workType}} 
          @onChange={{action (mut this.workType)}}
        />

        <f.Input @name="title" @label="js.academic_repository.form.work_title" @required={{true}} />
        <f.Textarea @name="abstract" @label="js.academic_repository.form.abstract" />

        {{!-- Dinamik Kategori Seçicisi: Sadece journal_article ise göster --}}
        {{#if (eq this.workType "journal_article")}}
          <f.Input @name="venue_name" @label="js.academic_repository.form.journal_name" />
        {{/if}}

        {{#if (eq this.workType "book")}}
          <f.Input @name="isbn" @label="js.academic_repository.form.isbn" />
          <f.Input @name="venue_name" @label="js.academic_repository.form.publisher" />
        {{/if}}

        <f.Submit @label="js.academic_repository.form.submit" />
      </Form>
    </div>
  </template>
}